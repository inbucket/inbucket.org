import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import lustre
import lustre/attribute.{attribute} as attr
import lustre/element.{element}
import lustre/element/html.{text}
import lustre/event
import lustre/vdom/vnode.{type Element}

pub fn main() -> Nil {
  io.println("Hello from configurator!")

  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(
    format: String,
    show_defaults: Bool,
    entries: dict.Dict(String, ConfigEntry),
    keys: List(String),
  )
}

type ConfigEntry {
  ConfigEntry(
    id: String,
    // Environment variable name.
    name: String,
    // Default value.
    default: String,
    // Current value.
    value: String,
  )
}

fn init(_flags) -> Model {
  let add = fn(model: Model, id, name, default) {
    Model(
      ..model,
      entries: dict.insert(
        model.entries,
        id,
        ConfigEntry(id, name, default, default),
      ),
      keys: [id, ..model.keys],
    )
  }

  // Add ordered config entries with defaults.
  let model =
    Model(
      format: "BashExport",
      show_defaults: False,
      entries: dict.new(),
      keys: [],
    )
    |> add("logLevel", "INBUCKET_LOGLEVEL", "info")
    |> add("mailboxNaming", "INBUCKET_MAILBOXNAMING", "local")
    |> add("smtp.addr", "INBUCKET_SMTP_ADDR", "0.0.0.0:2500")
    |> add("smtp.domain", "INBUCKET_SMTP_DOMAIN", "inbucket")
    |> add("smtp.maxRecipients", "INBUCKET_SMTP_MAXRECIPIENTS", "200")
    |> add("smtp.maxMessageBytes", "INBUCKET_SMTP_MAXMESSAGEBYTES", "10240000")
    |> add("smtp.defaultAccept", "INBUCKET_SMTP_DEFAULTACCEPT", "true")
    |> add("smtp.acceptDomains", "INBUCKET_SMTP_ACCEPTDOMAINS", "")
    |> add("smtp.rejectDomains", "INBUCKET_SMTP_REJECTDOMAINS", "")
    |> add("smtp.defaultStore", "INBUCKET_SMTP_DEFAULTSTORE", "true")
    |> add("smtp.storeDomains", "INBUCKET_SMTP_STOREDOMAINS", "")
    |> add("smtp.discardDomains", "INBUCKET_SMTP_DISCARDDOMAINS", "")
    |> add("smtp.timeout", "INBUCKET_SMTP_TIMEOUT", "300s")
    |> add("smtp.tlsEnabled", "INBUCKET_SMTP_TLSENABLED", "false")
    |> add("smtp.tlsPrivKey", "INBUCKET_SMTP_TLSPRIVKEY", "")
    |> add("smtp.tlsCert", "INBUCKET_SMTP_TLSCERT", "")
    |> add("pop3.addr", "INBUCKET_POP3_ADDR", "0.0.0.0:1100")
    |> add("pop3.domain", "INBUCKET_POP3_DOMAIN", "inbucket")
    |> add("pop3.timeout", "INBUCKET_POP3_TIMEOUT", "600s")
    |> add("web.addr", "INBUCKET_WEB_ADDR", "0.0.0.0:9000")
    |> add("web.basePath", "INBUCKET_WEB_BASEPATH", "")
    |> add("web.uiDir", "INBUCKET_WEB_UIDIR", "ui/dist")
    |> add("web.greetingFile", "INBUCKET_WEB_GREETINGFILE", "ui/greeting.html")
    |> add("web.monitorVisible", "INBUCKET_WEB_MONITORVISIBLE", "true")
    |> add("web.monitorHistory", "INBUCKET_WEB_MONITORHISTORY", "30")
    |> add("web.pprof", "INBUCKET_WEB_PPROF", "false")
    |> add("storage.type", "INBUCKET_STORAGE_TYPE", "memory")
    |> add("storage.params", "INBUCKET_STORAGE_PARAMS", "")
    |> add("storage.retentionPeriod", "INBUCKET_STORAGE_RETENTIONPERIOD", "24h")
    |> add("storage.retentionSleep", "INBUCKET_STORAGE_RETENTIONSLEEP", "50ms")
    |> add("storage.mailboxMsgCap", "INBUCKET_STORAGE_MAILBOXMSGCAP", "500")

  Model(..model, keys: list.reverse(model.keys))
}

type Msg {
  UserChangedFormat(to: String)
  UserChangedShowDefaults(to: Bool)
  UserChangedValue(of: String, to: String)
}

fn update(model: Model, msg: Msg) -> Model {
  echo msg

  case msg {
    UserChangedFormat(to: format) -> Model(..model, format: format)
    UserChangedShowDefaults(to: show_defaults) ->
      Model(..model, show_defaults: show_defaults)
    UserChangedValue(of: key, to: value) -> {
      // Update entry value if present.
      let entries =
        dict.get(model.entries, key)
        |> result.map(fn(e) {
          dict.insert(model.entries, key, ConfigEntry(..e, value: value))
        })
        |> result.unwrap(model.entries)

      Model(..model, entries: entries)
    }
  }
}

fn view(model: Model) {
  let entries = model.entries

  html.div([], [
    html.h1([], [text("Inbucket Configurator")]),
    html.div([attr.id("config-form")], [
      details("Global", [
        html.div([attr.class("config-item")], [
          html.h3([], [text("Log Level")]),
          html.p([], [
            text(
              " This setting controls the verbosity of log output. A small desktop installation should
          probably select info, but a busy shared installation would be better off with warn or error. ",
            ),
          ]),
          radio(entries, "logLevel", "error", [text("output errors only")]),
          radio(entries, "logLevel", "warn", [
            text("output errors, and warnings"),
          ]),
          radio(entries, "logLevel", "info", [
            text("output errors, warnings, and informational messages"),
          ]),
          radio(entries, "logLevel", "debug", [
            text("output everything, including debugging information"),
          ]),
        ]),
        html.div([attr.class("config-item")], [
          html.h3([], [text("Mailbox Naming")]),
          html.p([], [
            text(
              "The mailbox naming setting determines the name of a mailbox for an incoming
        message, and thus where it must be retrieved from later.",
            ),
          ]),
          radio(entries, "mailboxNaming", "local", [
            text("ensures the domain is removed, such that:"),
            html.ul([], [
              html.li([], [
                code("james@inbucket.org"),
                text(" is stored in "),
                code("james"),
              ]),
              html.li([], [
                code("james+spam@inbucket.org"),
                text(" is stored in "),
                code("james"),
              ]),
            ]),
          ]),
          radio(entries, "mailboxNaming", "full", [
            text("retains the domain as part of the name, such that:"),
            html.ul([], [
              html.li([], [
                code("james@inbucket.org"),
                text(" is stored in "),
                code("james@inbucket.org"),
              ]),
              html.li([], [
                code("james+spam@inbucket.org"),
                text(" is stored in "),
                code("james@inbucket.org"),
              ]),
            ]),
          ]),
          radio(entries, "mailboxNaming", "domain", [
            text("ensures the local-part is removed, such that:"),
            html.ul([], [
              html.li([], [
                code("james@inbucket.org"),
                text(" is stored in "),
                code("inbucket.org"),
              ]),
              html.li([], [
                code("matt@inbucket.org"),
                text(" is stored in "),
                code("inbucket.org"),
              ]),
              html.li([], [
                code("matt@noinbucket.com"),
                text(" is stored in "),
                code("notinbucket.com"),
              ]),
            ]),
          ]),
        ]),
      ]),
      details("SMTP", [
        text_input(
          entries,
          "smtp.addr",
          "address:port",
          "Address and Port",
          True,
          [
            text(
              " The IPv4 address and TCP port number the SMTP server should listen on, separated by a colon.
      Some operating systems may prevent Inbucket from listening on port 25 without escalated
      privileges.  Using an IP address of 0.0.0.0 will cause Inbucket to listen on all available
      network interfaces. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "smtp.domain",
          "host or domain name",
          "Greeting Domain",
          True,
          [
            text(" The domain used in the SMTP greeting: "),
            code("220 domain Inbucket SMTP ready"),
            text(
              ".  Most SMTP
      clients appear to ignore this value. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "smtp.maxRecipients",
          "positive integer",
          "Maximum Recipients",
          True,
          [
            text(" Maximum number of recipients allowed (SMTP "),
            code("RCPT TO"),
            text(
              " phase).  If you are testing
      a mailing list server, you may need to increase this value.  For comparison, the
      Postfix SMTP server uses a default of 1000, it would be unwise to exceed this. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "smtp.maxMessageBytes",
          "positive integer bytes",
          "Maximum Message Size",
          True,
          [
            text(
              " Maximum allowable size of a message (including headers) in bytes.  Messages
      exceeding this size will be rejected during the SMTP ",
            ),
            code("DATA"),
            text(" phase. "),
          ],
        ),
        html.div([attr.class("config-item")], [
          html.h3([], [text("Default Recipient Accept Policy")]),
          radio(entries, "smtp.defaultAccept", "true", [
            text(
              "accept mail to any domain unless present in the reject domains list.",
            ),
          ]),
          radio(entries, "smtp.defaultAccept", "false", [
            text(
              "recipients will be rejected unless their domain is present in the accept domains list.",
            ),
          ]),
        ]),
        text_input(
          model.entries,
          "smtp.acceptDomains",
          "comma separated domains",
          "Accepted Recipient Domain List",
          entry_equals(entries, "smtp.defaultAccept", "false"),
          [
            text(" List of domains to accept mail for when "),
            html.em([], [text("Default Recipient Accept Policy")]),
            text(" is false; has no effect when true. "),
          ],
        ),
        text_input(
          model.entries,
          "smtp.rejectDomains",
          "comma separated domains",
          "Rejected Recipient Domain List",
          entry_equals(entries, "smtp.defaultAccept", "true"),
          [
            text(" List of domains to reject mail for when "),
            html.em([], [text("Default Recipient Accept Policy")]),
            text(" is true; has no effect when false. "),
          ],
        ),
        html.div([attr.class("config-item")], [
          html.h3([], [text("Default Recipient Store Policy")]),
          radio(entries, "smtp.defaultStore", "true", [
            text(
              "store mail sent to any domain unless present in the discard domains list.",
            ),
          ]),
          radio(entries, "smtp.defaultStore", "false", [
            text(
              "messages will be discarded unless their domain is present in the store domains list.",
            ),
          ]),
        ]),
        text_input(
          model.entries,
          "smtp.storeDomains",
          "comma separated domains",
          "Stored Recipient Domain List",
          entry_equals(entries, "smtp.defaultStore", "false"),
          [
            text(" List of domains to store mail for when "),
            html.em([], [text("Default Recipient Store Policy")]),
            text(
              " is false;
      has no effect when true. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "smtp.discardDomains",
          "comma separated domains",
          "Discarded Recipient Domain List",
          entry_equals(entries, "smtp.defaultStore", "true"),
          [
            text(
              " Mail sent to these domains will not be stored by Inbucket.  This is helpful if
      you are load or soak testing a service, and do not plan to inspect the resulting
      emails.  Messages sent to a domain other than this will be stored normally.
      Only has an effect when ",
            ),
            html.em([], [text("Default Recipient Store Policy")]),
            text(" is true. "),
          ],
        ),
        text_input(
          model.entries,
          "smtp.timeout",
          "duration ending in s for seconds, m for minutes",
          "Network Idle Timeout",
          True,
          [
            text(
              " Delay before closing an idle SMTP connection.  The SMTP RFC recommends 300
      seconds.  Consider reducing this *significantly* if you plan to expose Inbucket
      to the public internet. ",
            ),
          ],
        ),
        html.div([attr.class("config-item")], [
          html.h3([], [text("TLS Encryption Availability")]),
          radio(entries, "smtp.tlsEnabled", "true", [
            text("SMTP STARTTLS will be availble for opportunistic TLS. "),
          ]),
          radio(entries, "smtp.tlsEnabled", "false", [
            text("TLS encryption will be disabled. "),
          ]),
        ]),
        text_input(
          model.entries,
          "smtp.tlsPrivKey",
          "filename or path to private key",
          "TLS Private Key File",
          entry_equals(entries, "smtp.tlsEnabled", "true"),
          [
            text(
              " Specify the x509 Private key file to be used for TLS negotiation. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "smtp.tlsCert",
          "filename or path to the certificate key",
          "TLS Public Certificate File",
          entry_equals(entries, "smtp.tlsEnabled", "true"),
          [
            text(
              " Specify the x509 Certificate file to be used for TLS negotiation. ",
            ),
          ],
        ),
      ]),
      details("POP3", [
        text_input(
          model.entries,
          "pop3.addr",
          "address:port",
          "Address and Port",
          True,
          [
            text(
              " The IPv4 address and TCP port number the POP3 server should listen on, separated
      by a colon.  Some operating systems may prevent Inbucket from listening on port
      110 without escalated privileges.  Using an IP address of 0.0.0.0 will cause
      Inbucket to listen on all available network interfaces. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "pop3.domain",
          "host or domain name",
          "Greeting Domain",
          True,
          [
            html.p([], [text("The domain used in the POP3 greeting:")]),
            code("+OK Inbucket POP3 server ready <26641.1522000423@domain>"),
            html.p([], [text("Most POP3 clients appear to ignore this value.")]),
          ],
        ),
        text_input(
          model.entries,
          "pop3.timeout",
          "duration ending in s for seconds, m for minutes",
          "Network Idle Timeout",
          True,
          [
            text(
              " Delay before closing an idle POP3 connection.  The POP3 RFC recommends 600
      seconds.  Consider reducing this ",
            ),
            html.em([], [text("significantly")]),
            text(" if you plan to expose Inbucket to the public internet. "),
          ],
        ),
      ]),
      details("Web", [
        text_input(
          model.entries,
          "web.addr",
          "address:port",
          "Address and Port",
          True,
          [
            text(
              " The IPv4 address and TCP port number the HTTP server should listen on, separated
    by a colon.  Some operating systems may prevent Inbucket from listening on port
    80 without escalated privileges.  Using an IP address of 0.0.0.0 will cause
    Inbucket to listen on all available network interfaces. ",
            ),
          ],
        ),
        text_input(
          model.entries,
          "web.basePath",
          "empty or URI prefix",
          "Base Path",
          True,
          [
            html.p([], [
              text(
                "Base path prefix for UI and API URLs.  This option is used when you wish to
    root all Inbucket URLs to a specific path when placing it behind a
    reverse-proxy.",
              ),
            ]),
            html.p([], [
              text(" For example, setting the base path to "),
              code("prefix"),
              text(" will move:"),
            ]),
            html.ul([], [
              html.li([], [
                text("the Inbucket status page from "),
                code("/status"),
                text(" to "),
                code("/prefix/status"),
                text(","),
              ]),
              html.li([], [
                text("Bob's mailbox from "),
                code("/m/bob"),
                text(" to "),
                code("/prefix/m/bob"),
                text(", and"),
              ]),
              html.li([], [
                text("the REST API from "),
                code("/api/v1/*"),
                text(" to "),
                code("/prefix/api/v1/*"),
                text("."),
              ]),
            ]),
            html.p([], []),
          ],
        ),
        text_input(
          model.entries,
          "web.uiDir",
          "OS directory path",
          "UI Directory",
          True,
          [
            html.p([], [
              text(
                "This directory contains the templates and static assets for the web user
    interface.  You will need to change this if the current working directory
    doesn't contain the ",
              ),
              code("ui"),
              text(" directory at startup."),
            ]),
            html.p([], [
              text("Inbucket will load templates from the "),
              code("templates"),
              text(" sub-directory, and serve static assets from the "),
              code("static"),
              text(" sub-directory."),
            ]),
          ],
        ),
        text_input(
          model.entries,
          "web.greetingFile",
          "OS file path",
          "Greeting HTML File",
          True,
          [
            text(
              " The content of the greeting file will be injected into the front page of
    Inbucket.  It can be used to instruct users on how to send mail into your
    Inbucket installation, as well as link to REST documentation, etc. ",
            ),
          ],
        ),
        html.div([attr.class("config-item")], [
          html.h3([], [text("Monitor Visible")]),
          radio(model.entries, "web.monitorVisible", "true", [
            text(
              "the monitor tab will be available, allowing users to observe all
      messages received by Inbucket as they arrive. ",
            ),
          ]),
          radio(model.entries, "web.monitorVisible", "false", [
            text("the monitor will be hidden. "),
          ]),
          html.p([], [
            text(
              "This setting has no impact on the availability of the underlying WebSocket,
      which may be used by other parts of the Inbucket interface or continuous
      integration tests.",
            ),
          ]),
        ]),
        text_input(
          model.entries,
          "web.monitorHistory",
          "positive integer",
          "Monitor History",
          True,
          [
            html.p([], [
              text("The number of messages to remember on the "),
              html.em([], [text("server")]),
              text(" for new Monitor clients. Does not impact the amount of "),
              html.em([], [text("new")]),
              text(
                " messages displayed by the Monitor.
    Increasing this has no appreciable impact on memory use, but may slow down the
    Monitor user interface.",
              ),
            ]),
            html.p([], [
              text(
                "This setting also impacts the number of messages available via WebSocket.",
              ),
            ]),
            html.p([], [
              text(
                "Setting to 0 will disable the monitor, but will probably break new mail
    notifications in the web interface when I finally get around to implementing
    them.",
              ),
            ]),
          ],
        ),
        html.div([attr.class("config-item")], [
          html.h3([], [text("Expose Profiling Data")]),
          html.p([], [
            text(" If enabled, Go's pprof package will be installed to the "),
            code("/debug/pprof"),
            text(
              " URI.  This
        exposes detailed memory and CPU performance data for debugging Inbucket.  If you enable this
        option, please make sure it is not exposed to the public internet, as its use can
        significantly impact performance. ",
            ),
          ]),
          radio(model.entries, "web.pprof", "true", [
            text("Enables Go pprof debug URI. "),
          ]),
          radio(model.entries, "web.pprof", "false", [text("Disables pprof. ")]),
        ]),
      ]),
      details("Storage", [
        html.div([attr.class("config-item")], [
          html.h3([], [text("Type")]),
          html.p([], [
            text(
              "Selects the storage implementation to use.  Currently Inbucket supports:",
            ),
          ]),
          radio(model.entries, "storage.type", "file", [
            text(
              "stores messages as individual files in a nested directory structure
          based on the hash of the mailbox name.  Each mailbox also includes an index
          file to speed up enumeration of the mailbox contents.
          output errors only. ",
            ),
          ]),
          radio(model.entries, "storage.type", "memory", [
            text(
              "stores messages in RAM, they will be lost if Inbucket is restarted, or crashes, etc. ",
            ),
          ]),
          html.p([], [
            text(
              "File storage is recommended for larger/shared installations.  Memory is better
      suited to desktop or continuous integration test use cases.",
            ),
          ]),
        ]),
        text_input(
          model.entries,
          "storage.params",
          "see above",
          "Parameters",
          True,
          [
            html.p([], [
              text(
                "Parameters specific to the storage type selected.  Formatted as a comma
      separated list of key:value pairs.",
              ),
            ]),
            case dict.get(entries, "storage.type") {
              Ok(stype) if stype.value == "file" ->
                html.div([], [
                  html.h4([], [code("file"), text(" type parameters")]),
                  html.ul([], [
                    html.li([], [
                      code("path"),
                      text(
                        ": Operating system specific path to the directory where mail should be stored. ",
                      ),
                    ]),
                  ]),
                  html.p([], [text("example: "), code("path:/tmp/inbucket")]),
                ])

              Ok(stype) if stype.value == "memory" ->
                html.div([], [
                  html.h4([], [code("memory"), text(" type parameters")]),
                  html.ul([], [
                    html.li([], [
                      code("maxkb"),
                      text(
                        ": Maximum size of the mail store in kilobytes.  The oldest messages in
            the store will be deleted to enforce the limit.  In-memory storage has some
            overhead, for now it is recommended to set this to half the total amount of
            memory you are willing to allocate to Inbucket. ",
                      ),
                    ]),
                  ]),
                  html.p([], [text("example: "), code("maxkb:10240")]),
                ])

              _ -> text("Unrecognized storage type")
            },
          ],
        ),
        text_input(
          model.entries,
          "storage.retentionPeriod",
          "duration ending in m for minutes, h for hours",
          "Retention Period",
          True,
          [
            html.p([], [
              text(
                "If set, Inbucket will scan the contents of its mail store once per minute,
    removing messages older than this.  This will be enforced regardless of the type
    of storage configured.",
              ),
            ]),
            html.p([], [
              text(
                "Should be significantly longer than one minute, or 0 to disable.",
              ),
            ]),
          ],
        ),
        text_input(
          model.entries,
          "storage.retentionSleep",
          "duration ending in ms for milliseconds, s for seconds",
          "Retention Sleep",
          True,
          [
            text(
              " Duration to sleep between scanning each mailbox for expired messages.
    Increasing this number will reduce disk thrashing, but extend the length of time
    required to complete a scan of the entire mail store.

    This delay is still enforced for memory stores, but could be reduced from the
    default.  Setting to ",
            ),
            code("0"),
            text(" may degrade performance of HTTP/SMTP/POP3 services. "),
          ],
        ),
        text_input(
          model.entries,
          "storage.mailboxMsgCap",
          "positive integer",
          "Per Mailbox Message Cap",
          True,
          [
            text(
              " Maximum messages allowed in a single mailbox, exceeding this will cause older
    messages to be deleted from the mailbox.  A value of ",
            ),
            code("0"),
            text(" will disable cap enforcement. "),
          ],
        ),
      ]),
      details("Environment Variables", [
        html.div([], [
          html.label([], [
            html.select([event.on_change(UserChangedFormat)], [
              html.option([attr.value("BashExport")], "Bash Exports"),
              html.option([attr.value("DockerCompose")], "Docker Compose"),
              html.option([attr.value("DockerShell")], "Docker Shell"),
              html.option([attr.value("Systemd")], "Systemd"),
              html.option(
                [attr.value("KubernetesConfigMap")],
                "Kubernetes configMap",
              ),
            ]),
            text(" Output format "),
          ]),
        ]),
        html.div([], [
          html.label([], [
            html.input([
              event.on_check(UserChangedShowDefaults),
              attr.type_("checkbox"),
            ]),
            text(" Show variables that are set to their default value "),
          ]),
        ]),
        html.br([]),
        html.div([], env_lines(model)),
      ]),
    ]),
    html.br([]),
    html.p([], [
      text("Please open an "),
      html.a([attr.href("https://github.com/inbucket/inbucket.org/issues")], [
        text("issue on GitHub"),
      ]),
      text(" to report a problem with this tool."),
    ]),
  ])
}

fn code(txt: String) {
  html.code([], [text(txt)])
}

fn details(title, content) {
  html.details([attribute("open", "true")], [
    html.summary([attr.class("section")], [text(title)]),
    ..content
  ])
}

fn env_lines(model: Model) {
  list.map(model.keys, fn(key) {
    result.map(dict.get(model.entries, key), env_line(
      model.show_defaults,
      model.format,
      _,
    ))
  })
  |> result.values()
  |> result.values()
}

fn env_line(
  show_defaults: Bool,
  format: String,
  entry: ConfigEntry,
) -> Result(Element(a), Nil) {
  let format = {
    // TODO escape special characters
    let line = case format {
      "BashExport" -> "export " <> entry.name <> "=\"" <> entry.value <> "\""
      "DockerCompose" -> entry.name <> ": \"" <> entry.value <> "\""
      "DockerShell" -> "-e " <> entry.name <> "=\"" <> entry.value <> "\""
      "Systemd" -> "Environment=" <> entry.name <> "=" <> entry.value
      "KubernetesConfigMap" ->
        "  " <> entry.name <> ": \"" <> entry.value <> "\""
      _ -> "Unknown format: " <> format
    }
    html.div([attr.class("env-line")], [text(line)])
  }

  case show_defaults {
    False if entry.value == entry.default -> Error(Nil)
    True | False -> Ok(format)
  }
}

fn entry_equals(entries: dict.Dict(String, ConfigEntry), key, value) {
  case dict.get(entries, key) {
    Ok(entry) -> entry.value == value
    _ -> False
  }
}

fn radio(
  entries: dict.Dict(String, ConfigEntry),
  id: String,
  value: String,
  content: List(Element(Msg)),
) -> Element(Msg) {
  let checked =
    dict.get(entries, id)
    |> result.map(fn(e) { e.value == value })
    |> result.unwrap(False)

  html.div([], [
    html.label([], [
      html.input([
        attr.name(id),
        attr.value(value),
        attr.type_("radio"),
        attr.checked(checked),
        event.on_click(UserChangedValue(of: id, to: value)),
      ]),
      html.samp([], [text(value)]),
      text(": "),
      ..content
    ]),
  ])
}

fn text_input(
  entries: dict.Dict(String, ConfigEntry),
  id: String,
  hint: String,
  title: String,
  show: Bool,
  content: List(Element(Msg)),
) -> Element(Msg) {
  let value =
    dict.get(entries, id) |> result.map(fn(e) { e.value }) |> result.unwrap("")
  let styles = case show {
    True -> []
    False -> [#("display", "none")]
  }

  html.div([attr.class("config-item"), attr.styles(styles)], [
    html.h3([], [text(title)]),
    html.p([], content),
    html.label([], [
      html.input([
        attr.type_("text"),
        attr.value(value),
        event.on_input(UserChangedValue(of: id, to: _)),
      ]),
      text(" "),
      text(hint),
    ]),
  ])
}

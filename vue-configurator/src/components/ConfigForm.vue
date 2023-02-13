<template>
  <div id="config-form">
    <Zippy title="Global">
      <div class="config-item">
        <h3>Log Level</h3>
        <p>
          This setting controls the verbosity of log output. A small desktop installation should
          probably select info, but a busy shared installation would be better off with warn or error.
        </p>
        <div>
          <label>
            <input type="radio" value="error" v-model="inbucket.logLevel"/>
            <samp>error</samp>:
            output errors only.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" value="warn" v-model="inbucket.logLevel"/>
            <samp>warn</samp>:
            output errors and warnings.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" value="info" v-model="inbucket.logLevel"/>
            <samp>info</samp>:
            output errors, warnings and information about what Inbucket is doing.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" value="debug" v-model="inbucket.logLevel"/>
            <samp>debug</samp>:
            output everything, including debugging information.
          </label>
        </div>
      </div>
      <div class="config-item">
        <h3>Mailbox Naming</h3>
        <p>The mailbox naming setting determines the name of a mailbox for an incoming
        message, and thus where it must be retrieved from later.</p>
        <div>
          <label>
            <input type="radio" value="local" v-model="inbucket.mailboxNaming"/>
            <samp>local</samp>: ensures the domain is removed, such that:
            <ul>
              <li><tt>james@inbucket.org</tt> is stored in <tt>james</tt></li>
              <li><tt>james+spam@inbucket.org</tt> is stored in <tt>james</tt></li>
            </ul>
          </label>
        </div>
        <div>
          <label>
            <input type="radio" value="full" v-model="inbucket.mailboxNaming"/>
            <samp>full</samp>: retains the domain as part of the name, such that:
            <ul>
              <li><tt>james@inbucket.org</tt> is stored in <tt>james@inbucket.org</tt></li>
              <li><tt>james+spam@inbucket.org</tt> is stored in <tt>james@inbucket.org</tt></li>
            </ul>
          </label>
        </div>
        <div>
          <label>
            <input type="radio" value="domain" v-model="inbucket.mailboxNaming"/>
            <samp>domain</samp>: ensures the local-part is removed, such that:
            <ul>
              <li><tt>james@inbucket.org</tt> is stored in <tt>inbucket.org</tt></li>
              <li><tt>matt@inbucket.org</tt> is stored in <tt>inbucket.org</tt></li>
              <li><tt>matt@noinbucket.com</tt> is stored in <tt>notinbucket.com</tt></li>
            </ul>
          </label>
        </div>
      </div>
    </Zippy>

    <Zippy title="SMTP">
      <TextInput title="Address and Port"
                 hint="address:port"
                 v-model="inbucket.smtp.addr">
      The IPv4 address and TCP port number the SMTP server should listen on, separated by a colon.
      Some operating systems may prevent Inbucket from listening on port 25 without escalated
      privileges.  Using an IP address of 0.0.0.0 will cause Inbucket to listen on all available
      network interfaces.
      </TextInput>

      <TextInput title="Greeting Domain"
                 hint="host or domain name"
                 v-model="inbucket.smtp.domain">
      The domain used in the SMTP greeting: <tt>220 domain Inbucket SMTP ready</tt>.  Most SMTP
      clients appear to ignore this value.
      </TextInput>

      <TextInput title="Maximum Recipients"
                 hint="positive integer"
                 v-model="inbucket.smtp.maxRecipients">
      Maximum number of recipients allowed (SMTP <tt>RCPT TO</tt> phase).  If you are testing
      a mailing list server, you may need to increase this value.  For comparison, the
      Postfix SMTP server uses a default of 1000, it would be unwise to exceed this.
      </TextInput>

      <TextInput title="Maximum Message Size"
                 hint="positive integer bytes"
                 v-model="inbucket.smtp.maxMessageBytes">
      Maximum allowable size of a message (including headers) in bytes.  Messages
      exceeding this size will be rejected during the SMTP <tt>DATA</tt> phase.
      </TextInput>

      <div class="config-item">
        <h3>Default Recipient Accept Policy</h3>
        <div>
          <label>
            <input type="radio" :value="true" v-model="inbucket.smtp.defaultAccept"/>
            <samp>true</samp>:
            accept mail to any domain unless present in the reject domains list.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" :value="false" v-model="inbucket.smtp.defaultAccept"/>
            <samp>false</samp>:
            recipients will be rejected unless their domain is present in the accept domains list.
          </label>
        </div>
      </div>

      <TextInput v-show="!inbucket.smtp.defaultAccept"
                 title="Accepted Recipient Domain List"
                 hint="comma separated domains"
                 v-model="inbucket.smtp.acceptDomains">
      List of domains to accept mail for when <em>Default Recipient Accept Policy</em> is false;
      has no effect when true.
      </TextInput>

      <TextInput v-show="inbucket.smtp.defaultAccept"
                 title="Rejected Recipient Domain List"
                 hint="comma separated domains"
                 v-model="inbucket.smtp.rejectDomains">
      List of domains to reject mail for when <em>Default Recipient Accept Policy</em> is true;
      has no effect when false.
      </TextInput>

      <div class="config-item">
        <h3>Default Recipient Store Policy</h3>
        <div>
          <label>
            <input type="radio" :value="true" v-model="inbucket.smtp.defaultStore"/>
            <samp>true</samp>:
            store mail sent to any domain unless present in the discard domains list.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" :value="false" v-model="inbucket.smtp.defaultStore"/>
            <samp>false</samp>:
            messages will be discarded unless their domain is present in the store domains
            list.
          </label>
        </div>
      </div>

      <TextInput v-show="!inbucket.smtp.defaultStore"
                 title="Stored Recipient Domain List"
                 hint="comma separated domains"
                 v-model="inbucket.smtp.storeDomains">
      List of domains to store mail for when <em>Default Recipient Store Policy</em> is false;
      has no effect when true.
      </TextInput>

      <TextInput v-show="inbucket.smtp.defaultStore"
                 title="Discarded Recipient Domain List"
                 hint="comma separated domains"
                 v-model="inbucket.smtp.discardDomains">
      Mail sent to these domains will not be stored by Inbucket.  This is helpful if
      you are load or soak testing a service, and do not plan to inspect the resulting
      emails.  Messages sent to a domain other than this will be stored normally.
      Only has an effect when <em>Default Recipient Store Policy</em> is true.
      </TextInput>

      <TextInput title="Network Idle Timeout"
                 hint="duration ending in s for seconds, m for minutes"
                 v-model="inbucket.smtp.timeout">
      Delay before closing an idle SMTP connection.  The SMTP RFC recommends 300
      seconds.  Consider reducing this *significantly* if you plan to expose Inbucket
      to the public internet.
      </TextInput>

      <div class="config-item">
        <h3>TLS Encryption Availability</h3>
        <div>
          <label>
            <input type="radio" :value="true" v-model="inbucket.smtp.tlsEnabled"/>
            <samp>true</samp>:
            SMTP STARTTLS will be availble for opportunistic TLS.
          </label>
        </div>
        <div>
          <label>
            <input type="radio" :value="false" v-model="inbucket.smtp.tlsEnabled"/>
            <samp>false</samp>:
            TLS encryption will be disabled.
          </label>
        </div>
      </div>

      <TextInput title="TLS Private Key File"
                 v-show="inbucket.smtp.tlsEnabled"
                 hint="filename or path to private key"
                 v-model="inbucket.smtp.tlsPrivKey">
      Specify the x509 Private key file to be used for TLS negotiation.
      </TextInput>

      <TextInput title="TLS Public Certificate File"
                 v-show="inbucket.smtp.tlsEnabled"
                 hint="filename or path to the certificate key"
                 v-model="inbucket.smtp.tlsCert">
      Specify the x509 Certificate file to be used for TLS negotiation.
      </TextInput>
    </Zippy>

    <Zippy title="POP3">
      <TextInput title="Address and Port"
                 hint="address:port"
                 v-model="inbucket.pop3.addr">
      The IPv4 address and TCP port number the POP3 server should listen on, separated
      by a colon.  Some operating systems may prevent Inbucket from listening on port
      110 without escalated privileges.  Using an IP address of 0.0.0.0 will cause
      Inbucket to listen on all available network interfaces.
      </TextInput>

      <TextInput title="Greeting Domain"
                 hint="host or domain name"
                 v-model="inbucket.pop3.domain">
      <p>The domain used in the POP3 greeting:</p>
      <tt>+OK Inbucket POP3 server ready &lt;26641.1522000423@domain&gt;</tt>
      <p>Most POP3 clients appear to ignore this value.</p>
      </TextInput>

      <TextInput title="Network Idle Timeout"
                 hint="duration ending in s for seconds, m for minutes"
                 v-model="inbucket.pop3.timeout">
      Delay before closing an idle POP3 connection.  The POP3 RFC recommends 600
      seconds.  Consider reducing this <em>significantly</em> if you plan to expose Inbucket
      to the public internet.
      </TextInput>
    </Zippy>

    <Zippy title="Web">

    <TextInput title="Address and Port"
               hint="address:port"
               v-model="inbucket.web.addr">
    The IPv4 address and TCP port number the HTTP server should listen on, separated
    by a colon.  Some operating systems may prevent Inbucket from listening on port
    80 without escalated privileges.  Using an IP address of 0.0.0.0 will cause
    Inbucket to listen on all available network interfaces.
    </TextInput>

    <TextInput title="UI Directory"
               hint="OS directory path"
               v-model="inbucket.web.uiDir">
    <p>This directory contains the templates and static assets for the web user
    interface.  You will need to change this if the current working directory
    doesn't contain the <tt>ui</tt> directory at startup.</p>

    <p>Inbucket will load templates from the <tt>templates</tt> sub-directory, and serve
    static assets from the <tt>static</tt> sub-directory.</p>
    </TextInput>

    <TextInput title="Greeting HTML File"
               hint="OS file path"
               v-model="inbucket.web.greetingFile">
    The content of the greeting file will be injected into the front page of
    Inbucket.  It can be used to instruct users on how to send mail into your
    Inbucket installation, as well as link to REST documentation, etc.
    </TextInput>

    <div class="config-item">
      <h3>Template Caching</h3>
      <div>
        <label>
          <input type="radio" :value="true" v-model="inbucket.web.templateCache"/>
          <samp>true</samp>:
          cache HTML templates after first use.
        </label>
      </div>
      <div>
        <label>
          <input type="radio" :value="false" v-model="inbucket.web.templateCache"/>
          <samp>false</samp>:
          always load HTML templates from disk, useful during Inbucket development.
        </label>
      </div>
    </div>

    <TextInput title="Mailbox Prompt"
               hint="text string"
               v-model="inbucket.web.mailboxPrompt">
    <p>Text prompt displayed to the right of the mailbox name input field in the web
    interface.  Can be used to nudge your users into typing just the mailbox name
    instead of an entire email address.</p>

    <p>Set to an empty string to hide the prompt.</p>
    </TextInput>

    <TextInput title="Cookie Authentication Key"
               hint="text string"
               v-model="inbucket.web.cookieAuthKey">
    Inbucket stores session information in an encrypted browser cookie.  Unless
    specified, Inbucket generates a random key at startup.  The only notable data
    stored in a user session is the list of recently accessed mailboxes.
    </TextInput>

    <div class="config-item">
      <h3>Monitor Visible</h3>
      <div>
        <label>
          <input type="radio" :value="true" v-model="inbucket.web.monitorVisible"/>
          <samp>true</samp>:
          the monitor tab will be available, allowing users to observe all
          messages received by Inbucket as they arrive.
        </label>
      </div>
      <div>
        <label>
          <input type="radio" :value="false" v-model="inbucket.web.monitorVisible"/>
          <samp>false</samp>:
          the monitor will be hidden.
        </label>
      </div>
      <p>This setting has no impact on the availability of the underlying WebSocket,
      which may be used by other parts of the Inbucket interface or continuous
      integration tests.</p>
    </div>

    <TextInput title="Monitor History"
               hint="positive integer"
               v-model="inbucket.web.monitorHistory">
    <p>The number of messages to remember on the <em>server</em> for new Monitor clients.
    Does not impact the amount of <em>new</em> messages displayed by the Monitor.
    Increasing this has no appreciable impact on memory use, but may slow down the
    Monitor user interface.</p>

    <p>This setting also impacts the number of messages available via WebSocket.</p>

    <p>Setting to 0 will disable the monitor, but will probably break new mail
    notifications in the web interface when I finally get around to implementing
    them.</p>
    </TextInput>

    </Zippy>

    <Zippy title="Storage">

    <div class="config-item">
      <h3>Type</h3>
      <p>Selects the storage implementation to use.  Currently Inbucket supports:</p>
      <div>
        <label>
          <input type="radio" value="file" v-model="inbucket.storage.type"/>
          <samp>file</samp>:
          stores messages as individual files in a nested directory structure
          based on the hash of the mailbox name.  Each mailbox also includes an index
          file to speed up enumeration of the mailbox contents.
          output errors only.
        </label>
      </div>
      <div>
        <label>
          <input type="radio" value="memory" v-model="inbucket.storage.type"/>
          <samp>memory</samp>:
          stores messages in RAM, they will be lost if Inbucket is restarted,
          or crashes, etc.
        </label>
      </div>
      <p>File storage is recommended for larger/shared installations.  Memory is better
      suited to desktop or continuous integration test use cases.</p>
    </div>

    <TextInput title="Parameters"
               hint="see above"
               v-model="inbucket.storage.params">
      <p>Parameters specific to the storage type selected.  Formatted as a comma
      separated list of key:value pairs.</p>

      <div v-show="inbucket.storage.type == 'file'">
        <h4><tt>file</tt> type parameters</h4>
        <ul>
          <li>
            <tt>path</tt>: Operating system specific path to the directory where mail should be
            stored.
          </li>
        </ul>
        <p>example: <tt>path:/tmp/inbucket</tt></p>
      </div>

      <div v-show="inbucket.storage.type == 'memory'">
        <h4><tt>memory</tt> type parameters</h4>
        <ul>
          <li>
            <tt>maxkb</tt>: Maximum size of the mail store in kilobytes.  The oldest messages in
            the store will be deleted to enforce the limit.  In-memory storage has some
            overhead, for now it is recommended to set this to half the total amount of
            memory you are willing to allocate to Inbucket.
          </li>
        </ul>
        <p>example: <tt>maxkb:10240</tt></p>
      </div>
    </TextInput>

    <TextInput title="Retention Period"
               hint="duration ending in m for minutes, h for hours"
               v-model="inbucket.storage.retentionPeriod">
    <p>If set, Inbucket will scan the contents of its mail store once per minute,
    removing messages older than this.  This will be enforced regardless of the type
    of storage configured.</p>

    <p>Should be significantly longer than one minute, or 0 to disable.</p>
    </TextInput>

    <TextInput title="Retention Sleep"
               hint="duration ending in ms for milliseconds, s for seconds"
               v-model="inbucket.storage.retentionSleep">
    Duration to sleep between scanning each mailbox for expired messages.
    Increasing this number will reduce disk thrashing, but extend the length of time
    required to complete a scan of the entire mail store.

    This delay is still enforced for memory stores, but could be reduced from the
    default.  Setting to <tt>0</tt> may degrade performance of HTTP/SMTP/POP3 services.
    </TextInput>

    <TextInput title="Per Mailbox Message Cap"
               hint="positive integer"
               v-model="inbucket.storage.mailboxMsgCap">
    Maximum messages allowed in a single mailbox, exceeding this will cause older
    messages to be deleted from the mailbox.  A value of <tt>0</tt> will disable cap enforcement.
    </TextInput>

    </Zippy>

    <Zippy title="Environment Variables">
    <div>
      <label>
        <select v-model="format">
          <option value="bash">Bash Exports</option>
          <option value="compose">Docker Compose</option>
          <option value="docker">Docker Shell</option>
          <option value="systemd">Systemd</option>
          <option value="kubernetes">Kubernetes configMap</option>
        </select>
        Output format
      </label>
    </div>
    <div>
      <label>
        <input type="checkbox" v-model="showDefaults"/>
        Show variables that are set to their default value
      </label>
    </div>
    <br/>
    <EnvList
       :config="inbucket"
       :defaults="inbucketDefaults()"
       :format="format"
       :showDefaults="showDefaults"></EnvList>
    </Zippy>
  </div>
</template>

<script>
import EnvList from './EnvList'
import TextInput from './TextInput'
import Zippy from './Zippy'

export default {
  components: { EnvList, TextInput, Zippy },
  data () {
    return {
      format: 'bash',
      showDefaults: false,
      inbucket: this.inbucketDefaults()
    }
  },
  methods: {
    inbucketDefaults () {
      return {
        logLevel: 'info',
        mailboxNaming: 'local',
        smtp: {
          addr: '0.0.0.0:2500',
          domain: 'inbucket',
          maxRecipients: 200,
          maxMessageBytes: 10240000,
          defaultAccept: true,
          acceptDomains: '',
          rejectDomains: '',
          defaultStore: true,
          storeDomains: '',
          discardDomains: '',
          timeout: '300s',
          tlsEnabled: false,
          tlsPrivKey: '',
          tlsCert: ''
        },
        pop3: {
          addr: '0.0.0.0:1100',
          domain: 'inbucket',
          timeout: '600s'
        },
        web: {
          addr: '0.0.0.0:9000',
          uiDir: 'ui',
          greetingFile: 'ui/greeting.html',
          templateCache: true,
          mailboxPrompt: '@inbucket',
          cookieAuthKey: '',
          monitorVisible: true,
          monitorHistory: 30
        },
        storage: {
          type: 'memory',
          params: '',
          retentionPeriod: '24h',
          retentionSleep: '50ms',
          mailboxMsgCap: 500
        }
      }
    }
  }
}
</script>

<style>
h2 {
  border-bottom: solid 1px #000;
}

h3 {
  margin-top: 0;
}

samp {
  font-family: Consolas, Monaco, monospace;
  font-weight: bold;
}

tt {
  background-color: #d0dfef;
  font-family: Consolas, Monaco, monospace;
  padding: 1px 5px;
}

#config-form {
  margin: 20px auto;
  max-width: 800px;
}

.config-item {
  background-color: #e0efff;
  margin: 4px 0;
  padding: 10px;
}

input[type=text] {
  width: 300px;
}
</style>

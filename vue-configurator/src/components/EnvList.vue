<template>
  <div>
    <div class="env-line" v-for="(v, i) in this.variables" :key="i">
      {{ v }}
    </div>
  </div>
</template>

<script>
export default {
  props: ['config', 'defaults', 'format', 'showDefaults'],
  computed: {
    variables () {
      const c = this.config
      const d = this.defaults
      // All env vars sans the INBUCKET prefix.
      const vars = [
        {
          name: 'LOGLEVEL',
          value: c.logLevel,
          def: d.logLevel
        },
        {
          name: 'MAILBOXNAMING',
          value: c.mailboxNaming,
          def: d.mailboxNaming
        },
        {
          name: 'SMTP_ADDR',
          value: c.smtp.addr,
          def: d.smtp.addr
        },
        {
          name: 'SMTP_DOMAIN',
          value: c.smtp.domain,
          def: d.smtp.domain
        },
        {
          name: 'SMTP_MAXRECIPIENTS',
          value: c.smtp.maxRecipients,
          def: d.smtp.maxRecipients
        },
        {
          name: 'SMTP_MAXMESSAGEBYTES',
          value: c.smtp.maxMessageBytes,
          def: d.smtp.maxMessageBytes
        },
        {
          name: 'SMTP_DEFAULTACCEPT',
          value: c.smtp.defaultAccept,
          def: d.smtp.defaultAccept
        },
        {
          name: 'SMTP_ACCEPTDOMAINS',
          value: c.smtp.acceptDomains,
          def: d.smtp.acceptDomains
        },
        {
          name: 'SMTP_REJECTDOMAINS',
          value: c.smtp.rejectDomains,
          def: d.smtp.rejectDomains
        },
        {
          name: 'SMTP_DEFAULTSTORE',
          value: c.smtp.defaultStore,
          def: d.smtp.defaultStore
        },
        {
          name: 'SMTP_STOREDOMAINS',
          value: c.smtp.storeDomains,
          def: d.smtp.storeDomains
        },
        {
          name: 'SMTP_DISCARDDOMAINS',
          value: c.smtp.discardDomains,
          def: d.smtp.discardDomains
        },
        {
          name: 'SMTP_TIMEOUT',
          value: c.smtp.timeout,
          def: d.smtp.timeout
        },
        {
          name: 'SMTP_TLSENABLED',
          value: c.smtp.tlsEnabled,
          def: d.smtp.tlsEnabled
        },
        {
          name: 'SMTP_TLSPRIVKEY',
          value: c.smtp.tlsPrivKey,
          def: d.smtp.tlsPrivKey
        },
        {
          name: 'SMTP_TLSCERT',
          value: c.smtp.tlsCert,
          def: d.smtp.tlsCert
        },
        {
          name: 'POP3_ADDR',
          value: c.pop3.addr,
          def: d.pop3.addr
        },
        {
          name: 'POP3_DOMAIN',
          value: c.pop3.domain,
          def: d.pop3.domain
        },
        {
          name: 'POP3_TIMEOUT',
          value: c.pop3.timeout,
          def: d.pop3.timeout
        },
        {
          name: 'WEB_ADDR',
          value: c.web.addr,
          def: d.web.addr
        },
        {
          name: 'WEB_UIDIR',
          value: c.web.uiDir,
          def: d.web.uiDir
        },
        {
          name: 'WEB_GREETINGFILE',
          value: c.web.greetingFile,
          def: d.web.greetingFile
        },
        {
          name: 'WEB_TEMPLATECACHE',
          value: c.web.templateCache,
          def: d.web.templateCache
        },
        {
          name: 'WEB_MAILBOXPROMPT',
          value: c.web.mailboxPrompt,
          def: d.web.mailboxPrompt
        },
        {
          name: 'WEB_MONITORVISIBLE',
          value: c.web.monitorVisible,
          def: d.web.monitorVisible
        },
        {
          name: 'WEB_MONITORHISTORY',
          value: c.web.monitorHistory,
          def: d.web.monitorHistory
        },
        {
          name: 'WEB_PPROF',
          value: c.web.pprof,
          def: d.web.pprof
        },
        {
          name: 'STORAGE_TYPE',
          value: c.storage.type,
          def: d.storage.type
        },
        {
          name: 'STORAGE_PARAMS',
          value: c.storage.params,
          def: d.storage.params
        },
        {
          name: 'STORAGE_RETENTIONPERIOD',
          value: c.storage.retentionPeriod,
          def: d.storage.retentionPeriod
        },
        {
          name: 'STORAGE_RETENTIONSLEEP',
          value: c.storage.retentionSleep,
          def: d.storage.retentionSleep
        },
        {
          name: 'STORAGE_MAILBOXMSGCAP',
          value: c.storage.mailboxMsgCap,
          def: d.storage.mailboxMsgCap
        }
      ]
      // Filter redundant conditions.
      let displayVars = vars.filter((v) => {
        if (v.name === 'SMTP_ACCEPTDOMAINS' && c.smtp.defaultAccept) {
          return false
        }
        if (v.name === 'SMTP_REJECTDOMAINS' && !c.smtp.defaultAccept) {
          return false
        }
        if (v.name === 'SMTP_STOREDOMAINS' && c.smtp.defaultStore) {
          return false
        }
        if (v.name === 'SMTP_DISCARDDOMAINS' && !c.smtp.defaultStore) {
          return false
        }
        if (v.name === 'SMTP_TLSPRIVKEY' && !c.smtp.tlsEnabled) {
          return false
        }
        if (v.name === 'SMTP_TLSCERT' && !c.smtp.tlsEnabled) {
          return false
        }
        return true
      })
      if (!this.showDefaults) {
        displayVars = displayVars.filter((v) => { return v.value !== v.def })
      }

      switch (this.format) {
        case 'bash':
          return displayVars.map((v) => {
            return 'export INBUCKET_' + v.name + '="' + v.value + '"'
          })
        case 'compose':
          return displayVars.map((v) => {
            return 'INBUCKET_' + v.name + ': "' + v.value + '"'
          })
        case 'docker':
          return displayVars.map((v) => {
            return '-e INBUCKET_' + v.name + '="' + v.value + '" \\'
          })
        case 'systemd':
          return displayVars.map((v) => {
            return 'Environment=INBUCKET_' + v.name + '=' + v.value
          })
        case 'kubernetes':
          return displayVars.map((v) => {
            return 'INBUCKET_' + v.name + ': "' + v.value + '"'
          })
        default:
          // eslint-disable-next-line
          console.log('unknown output format: ' + this.format)
          return []
      }
    }
  }
}
</script>

<style>
.env-line {
  font-family: Consolas, Monaco, monospace;
}
</style>

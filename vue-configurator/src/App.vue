<template>
  <div id="app">
    <h1>Inbucket Configurator (Beta)</h1>
    <ConfigForm/>
    <br/>
    <p>
      Please open an
      <a href="https://github.com/jhillyerd/inbucket.org/issues">issue on GitHub</a>
      to report a problem with this tool.
    </p>
  </div>
</template>

<script>
import ConfigForm from './components/ConfigForm'

export default {
  name: 'App',
  components: {
    ConfigForm
  }
}
</script>

<style>
html, body, div {
  font-family: Verdana, Geneva, sans-serif;
}

#app {
  margin: 20px auto;
  max-width: 800px;
}
</style>

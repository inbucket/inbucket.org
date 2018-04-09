<template>
  <div id="app">
    <h1>Inbucket Configurator (Beta)</h1>
    <ConfigForm/>
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

h1 {
  margin: 20px auto;
  max-width: 800px;
}
</style>

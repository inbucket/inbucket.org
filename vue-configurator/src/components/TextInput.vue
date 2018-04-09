<template>
  <div class="config-item">
    <h3>{{ title }}</h3>
    <p><slot/></p>
    <label>
      <input type="text" v-model="text" @input="$emit('input', $event.target.value)"/>
      {{ hint }}
    </label>
  </div>
</template>

<script>
export default {
  props: ['title', 'value', 'hint'],
  data () {
    return {
      text: this.value
    }
  }
}
</script>

<style scoped>
</style>

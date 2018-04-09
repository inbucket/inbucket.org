<template>
  <div class="config-item">
    <h3>{{ title }}</h3>
    <p><slot/></p>
    <label>
      <input type="text" v-model="value" @input="$emit('input', $event.target.value)"/>
      {{ hint }}
    </label>
  </div>
</template>

<script>
export default {
  props: ['title', 'value', 'hint']
}
</script>

<style scoped>
</style>

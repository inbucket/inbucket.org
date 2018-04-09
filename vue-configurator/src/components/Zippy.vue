<template>
  <div>
    <h2 @click="show = !show">
      <span v-if="show">&#x25bc;</span>
      <span v-else>&#x25b6;</span>
      {{ title }}
    </h2>
    <div v-show="show">
      <slot/>
    </div>
  </div>
</template>

<script>
export default {
  props: ['title'],
  data () {
    return {
      show: true
    }
  }
}
</script>

<style scoped>
</style>

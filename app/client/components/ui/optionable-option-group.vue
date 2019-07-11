<template>
  <div class="row form-group">
    <label :for="fieldId">{{ displayName }}</label>

    <choices
      v-if="hasSelection"
      v-model="myValue"
      :name="fieldName"
      :id="fieldId"
      :multiple="selectMultiple"

      :options="selectionOptions"
      :params="{ shouldSort: false }"
    >
    </choices>
    <input v-else type="text" class="form-control" :name="fieldName" :id="fieldId" v-model="myValue">

    <small v-if="desc" class="form-text text-muted">{{ desc }}</small>
  </div>
</template>

<script>
import S from 'string'

export default {
  props: {
    options: Object,
    attributeName: String,
    prefix: String,
    value: { type: null },
  },

  data() {
    return {
      myValue: null
    }
  },

  computed: {
    displayName() {
      return S(this.options.name).humanize().s
    },

    idAttributePrefix() {
      return `${this.prefix}_${this.attributeName}`
    },

    fieldName() {
      return `${this.prefix}[${this.attributeName}][${this.options.name}]`
    },

    fieldId() {
      return `${this.idAttributePrefix}_${this.options.name}`
    },

    display() {
      return this.options.display
    },

    desc() {
      return this.display.desc
    },

    hasSelection() {
      return !!this.display.selection
    },

    selectionOptions() {
      return this.display.selection.map((item) => [item, item])
    },

    selectMultiple() {
      return this.options.type === 'array'
    },
  },

  created: function() {
    this.myValue = this.value
  },
}
</script>

<style lang="scss">
.choices {
  margin-bottom: 0px;

  .form-control {
    height: auto;
  }
}
</style>

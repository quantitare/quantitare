<template>
  <div class="row" v-on="{ mouseenter: showNewModuleButton, mouseleave: hideNewModuleButton }">
    <div class="col">
      <div class="row">
        <div class="col">
          <h3>{{ section.name }}</h3>
        </div>

        <div v-if="newModuleButton" class="col-2">
          <a href="/timeline/modules/new" title="Add new module" class="btn btn-outline-success btn-block">
            <font-awesome-icon icon="plus"></font-awesome-icon>
          </a>
        </div>
      </div>

      <component
        v-for="module in section.modules"
        :key="module.id"

        :is="componentForModule(module)"
        :id="module.id"
        :scale="scale"
        :date="date"
      >
      </component>
    </div>
  </div>
</template>

<script>
const COMPONENT_MODULE_PREFIX = 'module'

export default {
  props: {
    scale: String,
    date: String,
    section: Object
  },

  data() {
    return {
      newModuleButton: false
    }
  },

  methods: {
    componentForModule(module) {
      return `${COMPONENT_MODULE_PREFIX}-${module.component}`
    },

    showNewModuleButton() {
      this.newModuleButton = true
    },

    hideNewModuleButton() {
      this.newModuleButton = false
    }
  }
}
</script>

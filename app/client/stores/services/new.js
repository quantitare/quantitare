import Vue from 'vue/dist/vue.esm'

export default {
  actions: {
    refreshService({ dispatch }, payload) {
      dispatch('updateService', payload)
    },

    clearService({ dispatch }) {
      return new Promise((resolve, reject) => {
        dispatch('service/clear')
          .then(() => resolve())
      })
    },

    updateService({ dispatch }, payload) {
      return new Promise((resolve, reject) => {
        dispatch('service/update', payload)
          .then(() => resolve())
      })
    }
  }
}

import Vue from 'vue/dist/vue.esm'
import { promiseForDispatch } from 'utilities/store-helpers'

export default {
  actions: {
    refreshService({ dispatch }, payload) {
      dispatch('updateService', payload)
    },

    clearService({ dispatch }) {
      return promiseForDispatch(dispatch, 'service/clear')
    },

    updateService({ dispatch }, payload) {
      return promiseForDispatch(dispatch, 'service/update', payload)
    }
  }
}

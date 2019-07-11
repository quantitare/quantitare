import { promiseForDispatch } from 'utilities/store-helpers'

export default {
  actions: {
    updateSetting({ dispatch }, payload) {
      return promiseForDispatch(dispatch, 'settings/update', payload)
    }
  }
}

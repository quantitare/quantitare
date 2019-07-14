import { promiseForDispatch } from 'utilities/store-helpers'

export default {
  actions: {
    refreshScrobbler({ dispatch }, payload) {
      dispatch('updateScrobbler', payload)
        .then(() => dispatch('scrobbler/cacheOriginal'))
    },

    updateScrobbler({ dispatch }, payload) {
      return promiseForDispatch(dispatch, 'scrobbler/update', payload)
    }
  }
}

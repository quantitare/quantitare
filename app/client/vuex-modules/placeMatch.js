import modelCrud from 'vuex-extensions/model-crud';
import _ from 'lodash';

export default _.merge({
  state: {
    enabled: false,

    matchName: true,
    matchCoordinates: true
  },

  getters: {
    sourceFields(state, getters, rootState) {
      return {
        name: rootState.locationScrobble.name,
        longitude: rootState.locationScrobble.longitude,
        latitude: rootState.locationScrobble.latitude
      };
    }
  }
}, modelCrud);

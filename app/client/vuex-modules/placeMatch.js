import modelCrud from 'vuex-extensions/model-crud';
import _ from 'lodash';

export default _.merge({
  getters: {
    sourceFields(state, getters, rootState) {
      return {
        name: rootState.locationScrobble.name,
        longitude: rootState.locationScrobble.averageLongitude,
        latitude: rootState.locationScrobble.averageLatitude
      };
    }
  }
}, modelCrud);

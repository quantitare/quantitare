import modelCrud from 'vuex-extensions/model-crud';
import LocationScrobble from 'models/location-scrobble';
import _ from 'lodash';

export default _.merge({
  getters: {
    model(state) {
      return _.extend(new LocationScrobble, state);
    }
  }
}, modelCrud);

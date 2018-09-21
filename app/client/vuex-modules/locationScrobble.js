import modelCrud from 'vuex-extensions/model-crud';
import LocationScrobble from 'models/location-scrobble';

export default _.merge({
  getters: {
    model(state) {
      return _.extend(new LocationScrobble, state);
    }
  }
}, modelCrud);

import LocationScrobble from 'models/location-scrobble';
import _ from 'lodash';

export default {
  getters: {
    models(state) {
      return state.scrobbles.map((scrobble) => _.extend(new LocationScrobble, scrobble));
    }
  }
};

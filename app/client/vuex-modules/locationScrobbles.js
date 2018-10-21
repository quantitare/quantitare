import LocationScrobble from 'models/location-scrobble';
import timelineCollection from 'vuex-extensions/timeline-collection';
import _ from 'lodash';

export default _.merge({
  getters: {
    models(state) {
      return state.scrobbles.map((scrobble) => _.extend(new LocationScrobble, scrobble));
    }
  }
}, timelineCollection);

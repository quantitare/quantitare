import Vue from 'vue/dist/vue.esm';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  state: {
    placeEditMode: PE_CLOSED
  },

  mutations: {
    setPlaceId(state, newPlaceId) {
      state.locationScrobble.placeId = newPlaceId;
    },

    setPlace(state, newPlace) {
      state.place = newPlace;
    },

    setPlaceEditMode(state, newMode) {
      state.placeEditMode = newMode;
    },
  },

  actions: {
    updatePlace({ dispatch }, payload) {
      dispatch('place/update', payload);
    },

    updateLocationScrobble({ dispatch }, payload) {
      dispatch('locationScrobble/update', payload);
    },

    processPlaceId({ dispatch, state }) {
      const pth = state.locationScrobble.placeId ? `/places/${state.locationScrobble.placeId}.json` : '/places/new.json';

      dispatch('fetchPlace', pth);
    },

    fetchPlace({ dispatch }, path) {
      return new Promise((resolve, reject) => {
        Vue.http.get(path).then((response) => {
          dispatch('updatePlace', response.body);
          resolve();
        }, () => {
          reject();
        });
      });
    },

    setPlaceEditMode({ dispatch, commit }, newMode) {
      dispatch('processPlaceEditMode', newMode).then(() => {
        commit('setPlaceEditMode', newMode);
      });
    },

    processPlaceEditMode({ state, dispatch }, mode) {
      return new Promise((resolve, reject) => {
        switch (mode) {
          case PE_NEW:
            dispatch('fetchPlace', '/places/new.json').then(() => {
              dispatch('fillNewPlaceFields');
              resolve();
            }).catch(() => reject());
            break;
          case PE_CLOSED:
            dispatch('processPlaceId');
            resolve();
          case PE_CHANGE:
            resolve();
          default:
            resolve();
        }
      });
    },

    fillNewPlaceFields({ dispatch, state }) {
      if (!state.place.isNewRecord) return;

      dispatch('updatePlace', {
        name: state.locationScrobble.name,
        longitude: state.locationScrobble.averageLongitude,
        latitude: state.locationScrobble.averageLatitude
      });
    }
  }
};

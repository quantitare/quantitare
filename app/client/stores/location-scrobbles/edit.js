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

    fillNewPlaceFields(state) {
      if (!state.place.isNewRecord) return;

      state.place.name = state.locationScrobble.name;
      state.place.latitude = state.locationScrobble.averageLatitude;
      state.place.longitude = state.locationScrobble.averageLongitude;
    }
  },

  actions: {
    updatePlace({ dispatch }, payload) {
      dispatch('place/update', payload);
    },

    updatePlaceId({ dispatch, commit }, placeId) {
      const path = placeId ? `/places/${placeId}.json` : '/places/new.json';

      dispatch('fetchPlace', path).then(() => {
        commit('setPlaceId', placeId);
      });
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
          default:
            resolve();
        }
      });
    },

    fillNewPlaceFields({ commit }) {
      commit('fillNewPlaceFields');
    }
  }
};

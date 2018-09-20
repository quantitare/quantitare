import Vue from 'vue/dist/vue.esm';
import LocationScrobble from 'models/location-scrobble';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  namespaced: true,

  state: {
    locationScrobble: {},
    place: {},
    placeEditMode: PE_CLOSED
  },

  getters: {
    locationScrobbleModel(state) {
      return _.extend(new LocationScrobble, state.locationScrobble);
    },
  },

  mutations: {
    setPlaceId(state, newPlaceId) {
      state.locationScrobble.placeId = newPlaceId;
    },

    setPlace(state, newPlace) {
      state.place = newPlace;
    },

    setCategory(state, newCategory) {
      state.place.category = newCategory;
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
    updatePlaceId({ dispatch, commit }, placeId) {
      const path = placeId ? `/places/${placeId}.json` : '/places/new.json';

      dispatch('fetchPlace', path).then(() => {
        commit('setPlaceId', placeId);
      });
    },

    updateCategory({ commit }, category) {
      commit('setCategory', category);
    },

    fetchPlace({ commit }, path) {
      return new Promise((resolve, reject) => {
        Vue.http.get(path).then((response) => {
          commit('setPlace', response.body);
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

import Vue from 'vue/dist/vue.esm';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  state: {
    placeEdit: false,
  },

  getters: {
    placeEditMode(state) {
      return PE_CLOSED;
    }
  },

  mutations: {
    setPlace(state, newPlace) {
      state.place = newPlace;
    },

    setPlaceEdit(state, newState) {
      state.placeEdit = newState;
    },
  },

  actions: {
    cacheOriginals({ dispatch }) {
      return new Promise((resolve, reject) => {
        dispatch('locationScrobble/cacheOriginal')
          .then(() => dispatch('place/cacheOriginal'))
          .then(() => resolve());
      });
    },

    refreshPlace({ dispatch }, payload) {
      dispatch('updatePlace', payload)
        .then(() => dispatch('place/cacheOriginal'));
    },

    updatePlace({ dispatch }, payload) {
      return new Promise((resolve, reject) => {
        dispatch('place/update', payload)
          .then(() => resolve());
      });
    },

    refreshLocationScrobble({ dispatch }, payload) {
      dispatch('updateLocationScrobble', payload)
        .then(() => dispatch('locationScrobble/cacheOriginal'));
    },

    updateLocationScrobble({ dispatch }, payload) {
      return new Promise((resolve, reject) => {
        dispatch('locationScrobble/update', payload)
          .then(() => resolve());
      });
    },

    processPlaceId({ dispatch, state }) {
      const pth = state.locationScrobble.placeId ? `/places/${state.locationScrobble.placeId}.json` : '/places/new.json';

      return new Promise((resolve, reject) => {
        dispatch('fetchPlace', pth)
          .then(() => resolve())
          .catch(() => reject());
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

    closePlaceEdit({ dispatch }) {
      dispatch('processPlaceId')
        .then(() => dispatch('setPlaceEdit', false));
    },

    openPlaceEdit({ dispatch }, mode) {
      dispatch('processPlaceOpenMode', mode)
        .then(() => dispatch('setPlaceEdit', true));
    },

    setPlaceEdit({ dispatch, commit }, newState) {
      commit('setPlaceEdit', newState);
    },

    processPlaceOpenMode({ dispatch }, mode) {
      return new Promise((resolve, reject) => {
        switch (mode) {
          case PE_NEW:
            dispatch('fetchPlace', '/places/new.json')
              .then(() => {
                dispatch('fillNewPlaceFields');
                resolve();
              })
              .catch(() => reject());
            break;
          case PE_EDIT:
            resolve();
          default:
            reject();
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

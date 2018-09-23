import Vue from 'vue/dist/vue.esm';

export default {
  namespaced: true,

  mutations: {
    update(state, payload) {
      _.keys(payload).forEach((key) => state[key] = payload[key]);
    },

    cacheOriginal(state) {
      Vue.set(state, '_original', Object.assign({}, state));
    },

    restoreOriginal(state, propsToRestore) {
      if (propsToRestore) {
        _.keys(propsToRestore).forEach((prop) => state[prop] = state._original[prop]);
      } else {
        _.keys(state._original).forEach((prop) => {
          if (prop !== '_original') state[prop] = state._original[prop];
        });
      }
    }
  },

  actions: {
    update({ commit }, payload) {
      return new Promise((resolve, reject) => {
        commit('update', payload);
        resolve();
      });
    },

    cacheOriginal({ commit }) {
      return new Promise((resolve, reject) => {
        commit('cacheOriginal');
        resolve();
      });
    },

    restoreOriginal({ commit }, propsToRestore) {
      return new Promise((resolve, reject) => {
        commit('restoreOriginal', propsToRestore);
        resolve();
      });
    }
  }
};

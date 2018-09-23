import Vue from 'vue/dist/vue.esm';

export default {
  namespaced: true,

  mutations: {
    update(state, payload) {
      _.keys(payload).forEach((key) => state[key] = payload[key]);
    },

    cacheOriginal(state) {
      Vue.set(state, '_original', Object.assign({}, state));
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
    }
  }
};

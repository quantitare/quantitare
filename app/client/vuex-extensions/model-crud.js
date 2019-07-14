import Vue from 'vue/dist/vue.esm';

export default {
  namespaced: true,

  mutations: {
    update(state, payload) {
      _.keys(payload).forEach((key) => {
        let currentLevel = state
        let currentKey = key
        const subkeys = key.split('.')

        subkeys.forEach((subkey, idx) => {
          if (idx < subkeys.length - 1) currentLevel = currentLevel[subkey]
          currentKey = subkey
        })

        Vue.set(currentLevel, currentKey, payload[key])
      })
    },

    clear(state) {
      _.keys(state).forEach((key) => Vue.delete(state, key))
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

    clear({ commit }) {
      return new Promise((resolve, reject) => {
        commit('clear')
        resolve()
      })
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

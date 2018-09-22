export default {
  namespaced: true,

  mutations: {
    update(state, payload) {
      _.keys(payload).forEach((key) => state[key] = payload[key]);
    }
  },

  actions: {
    update({ commit }, payload) {
      return new Promise((resolve, reject) => {
        commit('update', payload);
        resolve();
      });
    }
  }
};

export default {
  namespaced: true,

  mutations: {
    update(state, payload) {
      _.keys(payload).forEach((key) => state[key] = payload[key]);
    }
  },

  actions: {
    update({ commit }, payload) {
      commit('update', payload);
    }
  }
};

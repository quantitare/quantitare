import _ from 'lodash';

export default {
  namespaced: true,

  state: {
    items: []
  },

  mutations: {
    addAlerts(state, newItems) {
      state.items = state.items.concat(newItems);
    },

    closeAlert(state, idx) {
      state.items.splice(idx, 1);
    }
  },

  actions: {
    addAlerts({ commit }, payload) {
      commit('addAlerts', payload);
    },

    closeAlert({ commit }, idx) {
      commit('closeAlert', idx);
    }
  }
};

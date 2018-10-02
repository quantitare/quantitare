export default {
  actions: {
    updateSetting({ dispatch }, payload) {
      return new Promise((resolve, reject) => {
        dispatch('settings/update', payload)
          .then(() => resolve());
      });
    }
  }
};

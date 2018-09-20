import _ from 'lodash';

export default () => {
  const vuexModulesComponent = require.context('vuex-modules', true, /.+\.js/);
  const vuexModules = {};

  vuexModulesComponent.keys().forEach((filename) => {
    const module = vuexModulesComponent(filename);
    const name = _.camelCase(filename.replace(/^\.\/(.*)\.\w+$/, '$1'));

    vuexModules[name] = module.default;
  });

  return vuexModules;
}

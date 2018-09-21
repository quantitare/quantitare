import _ from 'lodash';

export default (vuexModulesComponent) => {
  const vuexModules = {};

  vuexModulesComponent.keys().forEach((filename) => {
    const module = vuexModulesComponent(filename);
    const name = _.camelCase(filename.replace(/^\.\/(.*)\.\w+$/, '$1'));

    vuexModules[name] = module.default || module;
  });

  return vuexModules;
};

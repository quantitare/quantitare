import _ from 'lodash';
import Vue from 'vue/dist/vue.esm';

export default (requireComponent, componentNameOutput = '$1') => {
  requireComponent.keys().forEach((filename) => {
    const componentConfig = requireComponent(filename);
    const componentName = _.upperFirst(_.camelCase(filename.replace(/^\.\/(.*)\.\w+$/, componentNameOutput)));

    Vue.component(componentName, componentConfig.default || componentConfig)
  });
}

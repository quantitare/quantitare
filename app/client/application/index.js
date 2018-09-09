"use strict";

import 'bootstrap/dist/css/bootstrap';
import 'bootstrap';

import '@fortawesome/fontawesome-free/js/all';
import '@fortawesome/fontawesome-free/css/all';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

import _ from 'lodash';

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';
import VueDataScooper from 'vue-data-scooper';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from 'activestorage';

import 'styles/application';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);
Vue.use(VueDataScooper);

function registerRequiredComponents(requireComponent, componentNameOutput = '$1') {
  requireComponent.keys().forEach((filename) => {
    const componentConfig = requireComponent(filename);
    const componentName = _.upperFirst(_.camelCase(filename.replace(/^\.\/(.*)\.\w+$/, componentNameOutput)));

    Vue.component(componentName, componentConfig.default || componentConfig)
  });
}

// Set up global components
const baseComponent = require.context('components', false, /.+\.(vue|js)/);
registerRequiredComponents(baseComponent);
const uiComponent = require.context('components/ui', true, /.+\.(vue|js)/);
registerRequiredComponents(uiComponent);
const viewComponent = require.context('views', true, /.+\.(vue|js)/);
registerRequiredComponents(viewComponent, '$1-view');

Vue.component('font-awesome-icon', FontAwesomeIcon);

document.addEventListener('turbolinks:load', () => {
  // Set a CSRF token header in every Vue HTTP request.
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('app');

  if (el) {
    let data = el.dataset;
    el.querySelectorAll('.vue-data').forEach((element) => data = _.merge(data, element.dataset));
    data = _.mapValues(data, (value) => JSON.parse(value));

    window.app = new Vue({
      el,
      data,

      mounted() {
        // Allow fontawesome SVG icons to be loaded with Turbolinks.
        FontAwesome.dom.i2svg();
      }
    });
  }
});

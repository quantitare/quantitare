"use strict";

import 'bootstrap/dist/css/bootstrap';
import 'bootstrap';

import '@fortawesome/fontawesome-free/js/all';
import '@fortawesome/fontawesome-free/css/all';

import _ from 'lodash';

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';
import VueDataScooper from 'vue-data-scooper';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from 'activestorage';

import './styles/application';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);
Vue.use(VueDataScooper);

// Set up global components
const requireComponent = require.context('./components', false, /.+\.(vue|js)/);

requireComponent.keys().forEach((filename) => {
  const componentConfig = requireComponent(filename)
  const componentName = _.upperFirst(_.camelCase(filename.replace(/^\.\/(.*)\.\w+$/, '$1')))

  Vue.component(componentName, componentConfig.default || componentConfig)
});

document.addEventListener('turbolinks:load', () => {
  // Set a CSRF token header in every Vue HTTP request.
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('app');

  if (el) {
    let alerts = JSON.parse(el.dataset.alerts);

    window.app = new Vue({
      el,

      data: { alerts },

      mounted() {
        // Allow fontawesome SVG icons to be loaded with Turbolinks.
        FontAwesome.dom.i2svg();
      }
    });
  }
});

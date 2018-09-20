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
import Vuex from 'vuex';
import VueDataScooper from 'vue-data-scooper';

import { mapState } from 'vuex';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from 'activestorage';

import registerRequiredComponents from 'utilities/register-required-components';
import vuexModuleLoader from 'utilities/vuex-module-loader';

import 'styles/application';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

Vue.use(TurbolinksAdapter);
Vue.use(VueResource);
Vue.use(Vuex);
Vue.use(VueDataScooper);

// Set up global components
const baseComponent = require.context('components', false, /.+\.(vue|js)/);
registerRequiredComponents(baseComponent);

const uiComponent = require.context('components/ui', true, /.+\.(vue|js)/);
registerRequiredComponents(uiComponent);

const viewComponent = require.context('views', true, /.+\.(vue|js)/);
registerRequiredComponents(viewComponent, '$1-view');

Vue.component('font-awesome-icon', FontAwesomeIcon);

document.addEventListener('turbolinks:load', () => {
  // Set a CSRF token header in every VueResource HTTP request.
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('app');

  if (el) {
    let moduleNames;
    let moduleStates;

    const moduleElements = document.querySelectorAll('.vuex-module');
    const moduleMap = _.map(moduleElements, (element) => element.dataset);

    moduleNames = _.flatMap(moduleMap, (e) => _.values(e));
    moduleStates = el.dataset;

    el.querySelectorAll('.vue-data').forEach((element) => moduleStates = _.merge(moduleStates, element.dataset));
    moduleStates = _.mapValues(moduleStates, (value) => JSON.parse(value));
    moduleNames = moduleNames.concat(_.keys(moduleStates));

    const modules = _.pick(vuexModuleLoader(), moduleNames);

    _.keys(modules).forEach((key) => {
      modules[key].state = modules[key].state || {};
      _.merge(modules[key].state, moduleStates[key]);
    });

    const store = new Vuex.Store({ modules });

    window.app = new Vue({
      el,
      store,

      computed: mapState(['alerts']),

      mounted() {
        // Allow fontawesome SVG icons to be loaded with Turbolinks.
        FontAwesome.dom.i2svg();
      }
    });
  }
});

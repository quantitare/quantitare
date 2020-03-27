"use strict";

import 'bootstrap/dist/css/bootstrap';
import 'bootstrap';

import '@fortawesome/fontawesome-free/js/all';
import '@fortawesome/fontawesome-free/css/all';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

import _ from 'lodash';

import Vue from 'vue/dist/vue.esm';

import VueResource from 'vue-resource';
import Vuex from 'vuex';
import VueDataScooper from 'vue-data-scooper';

import { mapState } from 'vuex';

import Rails from '@rails/ujs';
import * as ActiveStorage from '@rails/activestorage';

import registerRequiredComponents from 'utilities/register-required-components';
import loadVuexData from 'utilities/load-vuex-data';

import 'styles/application';

Rails.start();
ActiveStorage.start();

Vue.use(VueResource);
Vue.use(Vuex);
Vue.use(VueDataScooper);

const storeComponents = require.context('stores', true, /.+\.js/);
const moduleComponents = require.context('vuex-modules', true, /.+\.js/);

// Set up global components
const baseComponent = require.context('components', false, /.+\.(vue|js)/);
registerRequiredComponents(baseComponent);

const uiComponent = require.context('components/ui', true, /.+\.(vue|js)/);
registerRequiredComponents(uiComponent);

const viewComponent = require.context('views', true, /.+\.(vue|js)/);
registerRequiredComponents(viewComponent, '$1-view');

Vue.component('font-awesome-icon', FontAwesomeIcon);

document.addEventListener('DOMContentLoaded', () => {
  // Set a CSRF token header in every VueResource HTTP request.
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('app');

  if (el) {
    let moduleNames;
    let moduleStates;

    let storeNames;

    const moduleElements = el.querySelectorAll('.vuex-module');
    const moduleMap = _.map(moduleElements, (element) => element.dataset);

    moduleNames = _.flatMap(moduleMap, (e) => _.values(e));
    moduleStates = el.dataset;

    el.querySelectorAll('.vue-data').forEach((element) => moduleStates = _.merge(moduleStates, element.dataset));
    moduleStates = _.mapValues(moduleStates, (value) => JSON.parse(value));
    moduleNames = moduleNames.concat(_.keys(moduleStates));


    const availableModules = loadVuexData(moduleComponents);
    const modules = _.pick(availableModules, moduleNames);

    _.keys(modules).forEach((key) => {
      modules[key].state = modules[key].state || {};
      _.merge(modules[key].state, moduleStates[key]);
    });

    const availableStoreData = loadVuexData(storeComponents);
    const storeElements = el.querySelectorAll('.vuex-store');
    const storeMap = _.map(storeElements, (element) => element.dataset);

    storeNames = _.flatMap(storeMap, (e) => _.values(e));
    const storeData = _.map(storeNames, (name) => availableStoreData[name]);

    const finalStore = _.merge({ modules }, ...storeData);

    const store = new Vuex.Store(finalStore);

    window.app = new Vue({
      el,
      store,

      computed: mapState(['alerts']),
    });
  }
});

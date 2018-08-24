"use strict";

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';
import VueDataScooper from 'vue-data-scooper';

import * as Choices from 'choices.js/assets/scripts/dist/choices.min';
import 'choices.js/assets/styles/scss/choices';

import './styles/scrobbler-form'

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);
Vue.use(VueDataScooper);

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('scrobbler-form');

  if (!el) return;

  const app = new Vue({
    el
  });

  const typeChoices = new Choices('#scrobbler_type', {
    classNames: {
      containerOuter: 'choices',
      containerInner: 'form-control',
    }
  });
});

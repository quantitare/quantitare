"use strict";

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';
import VueDataScooper from 'vue-data-scooper';

import choices from '../shared/components/choices';

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);
Vue.use(VueDataScooper);

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('location-scrobble-form');

  if (!el) return;

  window.locationScrobbleForm = new Vue({
    el,

    components: { choices },

    data: {
      errors: [],
      locationScrobbleMetadata: {}
    }
  });
});

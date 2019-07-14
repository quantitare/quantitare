"use strict";

import Vue from 'vue/dist/vue.esm';
import VueResource from 'vue-resource';

Vue.use(VueResource);

import timeline from './components/timeline.vue';

document.addEventListener('DOMContentLoaded', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('timeline');

  if (!el) return;

  const app = new Vue({
    el,
    components: { timeline },
    template: '<timeline/>',
  });
});

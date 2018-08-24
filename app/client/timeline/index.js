"use strict";

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);

import timeline from './components/timeline.vue';

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('timeline');

  if (!el) return;

  const app = new Vue({
    el,
    components: { timeline },
    template: '<timeline/>',
  });
});

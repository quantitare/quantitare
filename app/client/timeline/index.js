"use strict";

import timeline from './components/timeline.vue';

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  // document.body.appendChild(document.createElement('app'));

  const timelineApp = new Vue({
    el: '#timeline',
    template: '<timeline />',
    components: { timeline },
  });
});

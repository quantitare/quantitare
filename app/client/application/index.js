"use strict";

// import Vue from 'vue/dist/vue.esm';
// import TurbolinksAdapter from 'vue-turbolinks';
// import VueResource from 'vue-resource';

import 'bootstrap/dist/css/bootstrap';
import 'bootstrap';

import '@fortawesome/fontawesome-free/js/all';
import '@fortawesome/fontawesome-free/css/all';

import './styles/application'

import * as ActiveStorage from 'activestorage';

ActiveStorage.start();

// Allow fontawesome SVG icons to be loaded with Turbolinks.
document.addEventListener('turbolinks:load', () => {
  FontAwesome.dom.i2svg();
});

// import App from './components/app.vue';

// Vue.use(VueResource);
// Vue.use(TurbolinksAdapter);

// document.addEventListener('turbolinks:load', () => {
//   Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
//   document.body.appendChild(document.createElement('app'));

//   const app = new Vue({
//     el: 'app',
//     template: '<App/>',
//     components: { App },
//   });

//   console.log('app');
// });

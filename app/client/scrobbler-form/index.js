"use strict";

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource';
import VueDataScooper from 'vue-data-scooper';

import './styles/scrobbler-form';
import choices from '../shared/components/choices';

Vue.use(VueResource);
Vue.use(TurbolinksAdapter);
Vue.use(VueDataScooper);

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const el = document.getElementById('scrobbler-form');

  if (!el) return;

  window.scrobblerForm = new Vue({
    el,

    components: { choices },

    data: {
      errors: [],

      scrobblerMetadata: {
        ready: false
      },
    },

    methods: {
      typeChanged(value) {
        this.scrobbler.type = value;
        this.loadTypeOptions(this.scrobbler.type);
      },

      loadTypeOptions(type) {
        this.$http.get('/scrobblers/type_data', { params: { type: type } }).then(
          (response) => {
            this.scrobblerMetadata = response.body;
          },

          (response) => {
            console.log('oops'); // TODO: Display some error message.
          }
        );
      }
    },

    mounted() {
      this.loadTypeOptions(this.scrobbler.type);
    }
  });
});

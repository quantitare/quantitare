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

  window.scrobblerForm = new Vue({
    el,

    data: {
      errors: [],

      scrobblerMetadata: {
        ready: false
      },
    },

    methods: {
      typeChanged(event) {
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

  const typeChoices = new Choices('#scrobbler_type', {
    itemSelectText: '',
    placeholder: true,

    classNames: {
      containerOuter: 'choices',
      containerInner: 'form-control',
    }
  });
});

"use strict";

import 'bootstrap/dist/css/bootstrap';
import 'bootstrap';

import '@fortawesome/fontawesome-free/js/all';
import '@fortawesome/fontawesome-free/css/all';

import './styles/application'

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from 'activestorage';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

// Allow fontawesome SVG icons to be loaded with Turbolinks.
document.addEventListener('turbolinks:load', () => {
  FontAwesome.dom.i2svg();
});

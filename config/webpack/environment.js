const { environment } = require('@rails/webpacker')

const erb = require('./loaders/erb')
const vue = require('./loaders/vue')
const sass = require('./loaders/sass')

const VueLoaderPlugin = require('vue-loader/lib/plugin')

environment.loaders.append('erb', erb)
environment.loaders.prepend('vue', vue)
environment.loaders.append('sass', sass)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())

module.exports = environment

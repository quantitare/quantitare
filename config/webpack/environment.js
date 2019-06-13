const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const vue =  require('./loaders/vue')
const { VueLoaderPlugin } = require('vue-loader')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('erb', erb)
environment.loaders.append('vue', vue)
module.exports = environment

import modelCrud from 'vuex-extensions/model-crud'
import Scrobbler from 'models/scrobbler'
import _ from 'lodash'

export default _.merge({
  getters: {
    model(state) {
      return _.extend(new Scrobbler, state)
    }
  }
}, modelCrud)

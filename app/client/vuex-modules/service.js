import modelCrud from 'vuex-extensions/model-crud'
import Service from 'models/service'
import _ from 'lodash'

export default _.merge({
  getters: {
    model(state) {
      return _.extend(new Service, state)
    }
  }
}, modelCrud)

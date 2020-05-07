import * as Choices from 'choices.js/public/assets/scripts/choices'

import locationCategories from './choices_formatters/location_categories'
import placesGrouped from './choices_formatters/places_grouped'

export default class {
  constructor(name) {
    this.name = name
  }

  get strategy() {
    return this.strategies[this.name]
  }

  get strategies() {
    return {
      locationCategories,
      placesGrouped
    }
  }

  get dataFormatter() {
    return (data) =>  this.strategy.formatData(data)
  }

  get templater() {
    return (template) => {
      return {
        choice: (classNames, data, ...rest) => {
          const opts = this.strategy.formatSelect(data)

          return Object.assign(Choices.defaults.templates.choice.call(this, classNames, data, ...rest), opts)
        },

        item: (classNames, data, ...rest) => {
          const opts = this.strategy.formatItem ? this.strategy.formatItem(data) : this.strategy.formatSelect(data)

          return Object.assign(Choices.defaults.templates.item.call(this, classNames, data, ...rest), opts)
        },
      }
    }
  }
}

import { Controller } from 'stimulus'
import * as Choices from 'choices.js/public/assets/scripts/choices'

const formatChoices = (data) => {
  if (!data[0].grouping) return

  return data.map((grouping, idx) => {
    return {
      label: grouping.label,
      id: grouping.id,
      disabled: false,
      choices: grouping.places.map((place) => {
        return {
          value: place.id,
          label: place.name,
          customProperties: { icon: place.icon }
        }
      })
    }
  })
}

const formatSelect = (data) => {
  const opts = {}
  const customProperties = JSON.parse(data.customProperties || '{}')

  if (customProperties.icon) {
    opts.innerHTML = `<i class="${customProperties.icon.data} mr-2"></i> ${data.label}`
  }

  return opts
}

export default class extends Controller {
  static targets = ['select']

  initialize() {
    this.choices = new Choices(this.selectTarget, this.choicesParams)

    this.selectObserver = new MutationObserver((mutationList, observer) => {
      mutationList.forEach((mutation) => this.handleSelectMutation(mutation))
    })

    this.selectObserver.observe(this.selectTarget, { attributes: true })

    if (this.searchPath) this.fetchChoicesFromPath()
  }

  disconnect() {
    this.choices.destroy()
    this.selectObserver.disconnect()
  }

  fetchChoicesFromPath() {
    this.choices.setChoices(() => {
      return fetch(this.searchPath)
        .then((response) => response.json())
        .then((data) => formatChoices(data))
        .catch((data) => console.log(data))
    })
  }

  handleSelectMutation(mutation) {
    if (mutation.attributeName !== 'disabled') return

    this.selectTarget.disabled ? this.choices.disable() : this.choices.enable()
  }

  get choicesParams() {
    const params = {
      classNames: { containerOuter: this.outerClassName, containerInner: this.innerClassName },
      removeItemButton: true,
      duplicateItemsAllowed: false,

      callbackOnCreateTemplates: (template) => {
        return {
          choice: (classNames, data, ...rest) => {
            const opts = formatSelect(data)

            return Object.assign(Choices.defaults.templates.choice.call(this, classNames, data, ...rest), opts)
          },

          item: (classNames, data, ...rest) => {
            const opts = formatSelect(data)

            return Object.assign(Choices.defaults.templates.item.call(this, classNames, data, ...rest), opts)
          }
        }
      }
    }

    return params
  }

  get outerClassName() {
    const base = ['choices']

    if (this.data.has('outer-class')) {
      base.push(this.data.get('outer-class'))
    }

    return base.join(' ')
  }

  get innerClassName() {
    const base = []

    if (this.data.has('inner-class')) {
      base.push(this.data.get('inner-class'))
    }

    return base.join(' ')
  }

  get searchPath() {
    return this.data.has('search-path') && this.data.get('search-path')
  }
}

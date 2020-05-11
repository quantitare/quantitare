import { Controller } from 'stimulus'
import * as Choices from 'choices.js/public/assets/scripts/choices'

import ChoicesFormatter from '../models/choices_formatter'

export default class extends Controller {
  static targets = ['select']

  connect() {
    this.choices = new Choices(this.selectTarget, this.choicesParams)
    this.selectObserver = new MutationObserver((mutationList, observer) => {
      mutationList.forEach((mutation) => this.handleSelectMutation(mutation))
    })

    this.selectObserver.observe(this.selectTarget, { attributes: true })

    if (this.searchPath) this.fetchChoicesFromPath()
  }

  disconnect() {
    this.selectObserver.disconnect()
    this.choices.destroy()
  }

  fetchChoicesFromPath() {
    this.choices.clearChoices()

    this.choices.setChoices(() => {
      return fetch(this.searchPath)
        .then((response) => response.json())
        .then(this.dataFormatter)
        .catch((error) => console.error(error))
    }).then((builder) => builder.setChoiceByValue(this.value))
  }

  handleSelectMutation(mutation) {
    if (mutation.attributeName !== 'disabled') return

    this.selectTarget.disabled ? this.choices.disable() : this.choices.enable()
  }

  get choicesParams() {
    const params = {
      classNames: { containerOuter: this.outerClassName, containerInner: this.innerClassName },
      removeItems: true,
      removeItemButton: true,
      duplicateItemsAllowed: false,

      placeholder: true,
      placeholderValue: 'Make a selection',
      searchPlaceholderValue: 'Make a selection',

      shouldSort: false,
    }

    if (this.formatter) params.callbackOnCreateTemplates = this.formatter.templater

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

  get value() {
    return this.data.has('value') && this.data.get('value')
  }

  get searchPath() {
    return this.data.has('search-path') && this.data.get('search-path')
  }

  get formatter() {
    return this.formatterName ? new ChoicesFormatter(this.formatterName) : null
  }

  get formatterName() {
    return this.data.has('formatter') && this.data.get('formatter')
  }

  get dataFormatter() {
    return this.formatter ? this.formatter.dataFormatter : (data) => data
  }
}

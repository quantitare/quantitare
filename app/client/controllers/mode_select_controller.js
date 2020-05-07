import { Controller } from 'stimulus'

/**
 * This is a superclass to add mode selection functionality to a controller. A "mode" is a list of targets (in Stimulus
 * parlance) that should be enabled, shown, or otherwise added to the DOM at a given time. Use the action `setMode` to
 * select the mode (with the `data-mode` attribute).
 *
 * Currently, you can do three things to a given target: enable/disable, show/hide, and insert/remove. Disabling a
 * target keeps the element visible, but will make it a read-only field (good for disabling an input). Hiding a target
 * will keep its contents in the DOM tree, but add the `d-none` class, effectively removing it from the visible page.
 * Removing a target will remove its inner HTML from the DOM tree completely.
 *
 * Generally, it is best to hide rather than remove, but removal is nice to have if you want to (for example) prevent
 * certain fields from being submitted completely. Please keep in mind that you will need to make sure that controllers
 * attached to the contents of "removable" targets implement appropriate `disconnect` logic.
 *
 * Classes that extend this class must have the following attributes:
 *
 * - *modes*, which returns an object whose keys are the names of each available mode, and whose values are an object
 *   describing what to show, insert, or disable.
 * - *hideableTargets*, which returns a list of strings corresponding to the names of the targets that you want to make
 *   hideable.
 * - *removableTargets*, which returns a list of strings corresponding to the names of the targets that you want to make
 *   removable
 * - *disableableTargets*, which returns a list of strings corresponding to the names of the targets that you want to
 *   make disableable
 *
 * The target lists must not have any overlaps.
 *
 * When the controller is attached, it first hides all hideable targets, removes all removable targets, and enables all
 * disableable targets. It then sets the mode to `initial`.
 *
 */
export default class extends Controller {
  connect() {
    this.removedTargets = new Map()

    this.refreshMode()
  }

  disconnect() {
    this.removedTargets = null
  }

  get mode() {
    if (this.data.has('mode')) return this.data.get('mode')

    return 'initial'
  }

  set mode(value) {
    this.data.set('mode', value)

    this.refreshMode()
  }

  refreshMode() {
    const targets = this.modes[this.mode]

    this.enableAllTargets()
    this.hideAllTargets()
    this.removeAllTargets()

    this.disableTargets(targets.disable || [])
    this.showTargets(targets.show || [])
    this.showConditionalTargets(targets.showIf || [])
    this.insertTargets(targets.insert || [])
    this.insertConditionalTargets(targets.insertIf || [])
  }

  setMode(e) {
    e.preventDefault()

    const newMode = e.currentTarget.dataset.mode
    if (!newMode) return

    this.mode = newMode
  }

  enableAllTargets() {
    this.disableableTargets.forEach((name) => this.toggleEnabledStateForTypes(name, true))
  }

  hideAllTargets() {
    this.hideableTargets.forEach((name) => this.toggleShownStateForTypes(name, false))
  }

  removeAllTargets() {
    this.removableTargets.forEach((name) => this.toggleInsertedStateForTypes(name, false))
  }

  disableTargets(targetNames) {
    targetNames.forEach((name) => this.toggleEnabledStateForTypes(name, false))
  }

  showTargets(targetNames) {
    targetNames.forEach((name) => this.toggleShownStateForTypes(name, true))
  }

  showConditionalTargets(targetSpecs) {
    targetSpecs.forEach((spec) => {
      if (spec.condition()) this.toggleShownStateForTypes(spec.target, true)
    })
  }

  insertTargets(targetNames) {
    targetNames.forEach((name) => this.toggleInsertedStateForTypes(name, true))
  }

  insertConditionalTargets(targetSpecs) {
    targetSpecs.forEach((spec) => {
      if (spec.condition()) this.toggleInsertedStateForTypes(spec.target, true)
    })
  }

  toggleEnabledStateForTypes(elementType, enable) {
    this[`${elementType}Targets`].forEach((element) => element.disabled = !enable)
  }

  toggleShownStateForTypes(elementType, show) {
    const action = show ? 'remove' : 'add'

    this[`${elementType}Targets`].forEach((element) => element.classList[action]('d-none'))
  }

  toggleInsertedStateForTypes(elementType, insert) {
    this[`${elementType}Targets`].forEach((element) => {
      insert ? this.insertElement(element) : this.removeElement(element)
    })
  }

  insertElement(element) {
    const value = this.removedTargets.get(element)

    if (value) {
      element.innerHTML = value

      this.removedTargets.delete(element)
    }
  }

  removeElement(element) {
    if (this.removedTargets.has(element)) return

    this.removedTargets.set(element, element.innerHTML)

    element.innerHTML = ''
  }
}

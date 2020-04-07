import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [
    'placeId',
    'placeSubmittable', 'placeInitializable', 'placeEditableInitializable', 'placeClosable',
    'placeFields'
  ]

  connect() {
    this.refreshPlaceElements()

    this.hidePlaceFields()
  }

  get placeButtonTypes() {
    return ['placeSubmittable', 'placeInitializable', 'placeEditableInitializable', 'placeClosable']
  }

  // ===--------------------------------===
  // Model attributes
  // ===--------------------------------===

  get placeId() {
    return this.hasPlaceIdTarget && parseInt(this.placeIdTarget.value)
  }

  // ===--------------------------------===
  // State getters
  // ===--------------------------------===

  get placeEditing() {
    return this.data.has('placeEditing') && this.data.get('placeEditing') == 'true'
  }

  get canPlaceSubmit() {
    return !this.placeEditing && this.placeId
  }

  get canPlaceInitialize() {
    return !this.placeEditing && !this.placeId
  }

  get canPlaceEditInitialize() {
    return
  }

  // ===--------------------------------===
  // Actions
  // ===--------------------------------===

  placeNewOpen(event) {
    event.preventDefault()

    this.showPlaceFields()
    this.refreshPlaceElements()
  }

  placeEditClose(event) {
    event.preventDefault()

    this.hidePlaceFields()
    this.refreshPlaceElements()
  }

  // ===--------------------------------===
  // Place button helpers
  // ===--------------------------------===

  refreshPlaceElements() {
    this.hidePlaceButtons()
    this.showRelevantPlaceButtons()

    this.setPlaceIdState()
  }

  hidePlaceButtons() {
    this.placeButtonTypes.forEach((buttonType) => this.hidePlaceButtonsForType(buttonType))
  }

  hidePlaceButtonsForType(buttonType) {
    this[`${buttonType}Targets`].forEach((element) => element.classList.add('d-none'))
  }

  showRelevantPlaceButtons() {
    if (this.canPlaceSubmit) {
      this.showPlaceButtonsForType('placeSubmittable')
    } else if (this.canPlaceInitialize) {
      this.showPlaceButtonsForType('placeInitializable')
    } else if (this.canPlaceEditInitialize) {
      this.showPlaceButtonsForType('placeEditableInitializable')
    } else {
      this.showPlaceButtonsForType('placeClosable')
    }
  }

  showPlaceButtonsForType(buttonType) {
    this[`${buttonType}Targets`].forEach((element) => element.classList.remove('d-none'))
  }

  setPlaceIdState() {
    this.placeIdTargets.forEach((element) => element.disabled = this.placeEditing)
  }

  // Place field helpers

  hidePlaceFields() {
    this.placeFieldsTargets.forEach((element) => element.classList.add('d-none'))
    this.data.set('placeEditing', 'false')

    this.refreshPlaceElements()
  }

  showPlaceFields() {
    this.placeFieldsTargets.forEach((element) => element.classList.remove('d-none'))
    this.data.set('placeEditing', 'true')
  }
}

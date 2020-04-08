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

  // ========----------------------------------------------========
  // Model attributes
  // ========----------------------------------------------========

  get placeId() {
    return this.hasPlaceIdTarget && parseInt(this.placeIdTarget.value)
  }

  // ========----------------------------------------------========
  // State getters
  // ========----------------------------------------------========

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

  // ========----------------------------------------------========
  // Actions
  // ========----------------------------------------------========

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

  // ========----------------------------------------------========
  // General helpers
  // ========----------------------------------------------========

  toggleElementsForTypes(elementType, show) {
    const action = show ? 'remove' : 'add'

    this[`${elementType}Targets`].forEach((element) => element.classList[action]('d-none'))
  }

  // ========----------------------------------------------========
  // Place button helpers
  // ========----------------------------------------------========

  refreshPlaceElements() {
    this.hidePlaceButtons()
    this.showRelevantPlaceButtons()

    this.setPlaceIdState()
  }

  hidePlaceButtons() {
    this.placeButtonTypes.forEach((buttonType) => this.hidePlaceButtonsForType(buttonType))
  }

  hidePlaceButtonsForType(buttonType) {
    this.toggleElementsForTypes(buttonType, false)
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
    this.toggleElementsForTypes(buttonType, true)
  }

  setPlaceIdState() {
    this.placeIdTargets.forEach((element) => element.disabled = this.placeEditing)
  }

  // ========----------------------------------------------========
  // Place field helpers
  // ========----------------------------------------------========

  hidePlaceFields() {
    this.toggleElementsForTypes('placeFields', false)
    this.data.set('placeEditing', 'false')

    this.refreshPlaceElements()
  }

  showPlaceFields() {
    this.toggleElementsForTypes('placeFields', true)
    this.data.set('placeEditing', 'true')
  }
}

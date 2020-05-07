import ModeSelectController from '../mode_select_controller'

export default class extends ModeSelectController {
  static targets = [
    'placeId',
    'placeSubmittable', 'placeInitializable', 'placeEditable', 'placeClosable',
    'newPlaceFields', 'editPlaceFields', 'matchFields'
  ]

  get hideableTargets() {
    return ['placeSubmittable', 'placeInitializable', 'placeEditable', 'placeClosable', 'matchFields']
  }

  get removableTargets()  {
    return ['newPlaceFields', 'editPlaceFields']
  }

  get disableableTargets() {
    return ['placeId']
  }

  get modes() {
    return {
      initial: {
        show: ['placeInitializable'],
        showIf: [{ target: 'placeEditable', condition: () => this.hasEditPlaceFieldsTarget }]
      },

      placeSelected: {
        show: ['matchFields', 'placeSubmittable']
      },

      newPlace: {
        insert: ['newPlaceFields'],
        show: ['matchFields', 'placeClosable', 'placeSubmittable'],
        disable: ['placeId']
      },

      editPlace: {
        insert: ['editPlaceFields'],
        show: ['matchFields', 'placeClosable', 'placeSubmittable'],
        disable: ['placeId']
      }
    }
  }

  get placeId() {
    return this.hasPlaceIdTarget && parseInt(this.placeIdTarget.value)
  }
}

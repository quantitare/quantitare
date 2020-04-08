import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['collapsible', 'state']

  initialize() {
    this.toggle()
  }

  toggle() {
    this.collapsibleTargets.forEach((target) => {
      if (this.showCollapsibleTargets) {
        target.classList.remove('d-none')
      } else {
        target.classList.add('d-none')
      }
    })
  }

  get showCollapsibleTargets() {
    return this.stateTarget.checked
  }
}

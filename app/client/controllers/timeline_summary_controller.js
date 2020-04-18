import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['component']

  connect() {
    fetch(this.modulePath)
      .then((response) => response.json())
      .then((json) => this.populateComponents(json))
  }

  populateComponents(json) {
    this.componentTargets.forEach((target) => {
      const data = json.summaries[target.dataset.component]

      target.querySelector('[data-attribute="total"]').innerHTML = data.total
      target.querySelector('[data-attribute="unit"]').innerHTML = data.unit
      target.querySelector('[data-attribute="label"]').innerHTML = data.label
    })
  }

  get modulePath() {
    return this.data.get('path')
  }
}

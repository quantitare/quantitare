import { Controller } from 'stimulus'
import $ from 'jquery'

export default class extends Controller {
  static targets = ['modal', 'modalContent']

  show(e) {
    const path = e.currentTarget.dataset.modalTemplatePath

    fetch(path)
      .then((response) => response.text())
      .then((html) => {
        this.modalContentTarget.innerHTML = html

        $(this.modalTarget).modal('show')
      })

  }
}

import { Controller } from "stimulus"

export default class extends Controller {
  submit() {
    this.element.submit()
  }

  get submitElement() {
    this.element.querySelector('input[type="submit"]')
  }
}

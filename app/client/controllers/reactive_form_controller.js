import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  submit() {
    Rails.fire(this.element, 'submit')
  }

  get submitElement() {
    this.element.querySelector('input[type="submit"]')
  }
}

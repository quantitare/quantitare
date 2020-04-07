import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['inactive', 'active', 'form', 'input', 'output']

  connect() {
    this.deactivate()

    this.formTarget.addEventListener('ajax:success', this.submitListener)
  }

  disconnect() {
    this.formTarget.removeEventListener('ajax:success', this.submitListener)
  }

  activate() {
    this.inactiveTarget.classList.add('d-none')
    this.activeTarget.classList.remove('d-none')
  }

  deactivate(event) {
    if (event) event.preventDefault()

    this.activeTarget.classList.add('d-none')
    this.inactiveTarget.classList.remove('d-none')
  }

  get submitListener() {
    return () => {
      this.outputTarget.innerHTML = this.inputTarget.value

      this.deactivate()
    }
  }
}

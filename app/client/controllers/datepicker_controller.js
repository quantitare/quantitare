import { Controller } from "stimulus"
import { Datepicker } from 'vanillajs-datepicker'

export default class extends Controller {
  initialize() {
    this.datepicker = new Datepicker(this.element, {
      buttonClass: 'btn',
      format: 'yyyy-mm-dd'
    })
  }
}

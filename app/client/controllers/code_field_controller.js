import { Controller } from 'stimulus'

import CodeMirror from 'codemirror'
import 'codemirror/mode/javascript/javascript.js'

import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/base16-light.css'

const DEFAULT_MODE_KEY = '_default'
const MODE_MAP = { json: 'javascript', [DEFAULT_MODE_KEY]: 'javascript' }

export default class extends Controller {
  connect() {
    console.log(MODE_MAP)
    this.editor = CodeMirror.fromTextArea(this.element, {
      mode: this.mode,
      json: this.isJSON,

      tabSize: 2,
      lineWrapping: true,
      viewportMargin: Infinity
    })
  }

  get modeKey() {
    return this.data.has('language') ? this.data.get('language') : DEFAULT_MODE_KEY
  }

  get mode() {
    return MODE_MAP[this.modeKey] || this.modeKey
  }

  get isJSON() {
    return this.modeKey === 'json'
  }
}

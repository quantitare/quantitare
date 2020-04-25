export default class ImageIcon {
  constructor(options) {
    this.options = options
  }

  tag({ size, className }) {
    const element = new Image()

    element.src = options[size]
    element.classList.add(...className.split(' '))

    return element.outerHTML
  }
}

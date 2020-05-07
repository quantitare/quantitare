export default class ImageIcon {
  constructor(options) {
    this.options = options
  }

  tag({ size, className, height, width }) {
    const element = new Image()

    element.src = this.options[size]

    element.height = height
    element.width = width
    if (className) element.classList.add(...className.split(' '))

    return element.outerHTML
  }
}

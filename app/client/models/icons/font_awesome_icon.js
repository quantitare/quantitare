export default class FontAwesomeIcon {
  constructor({ name }) {
    this.name = name
  }

  tag({ className }) {
    const element = document.createElement('i')

    element.classList.add(...this.name.split(' '))
    if (className) element.classList.add(...className.split(' '))

    return element.outerHTML
  }
}

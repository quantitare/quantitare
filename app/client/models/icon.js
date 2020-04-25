import FontAwesomeIcon from './icons/font_awesome_icon'
import ImageIcon from './icons/image_icon'

export default class Icon {
  static get types() {
    return {
      fa: FontAwesomeIcon,
      img: ImageIcon
    }
  }

  static build({ type, ...options }) {
    return new this.types[type](options)
  }
}

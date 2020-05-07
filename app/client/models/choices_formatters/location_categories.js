import Icon from '../icon'

export default {
  formatData: (data) => {
    return data.map((category) => {
      return {
        value: category.name,
        label: category.name,

        customProperties: {
          icon: category.icon,
          colors: category.colors
        }
      }
    })
  },

  formatSelect: (data) => {
    const opts = { innerHTML: '' }

    if (data.customProperties && data.customProperties.icon) {
      opts.innerHTML += Icon.build(data.customProperties.icon).tag({ className: 'mr-2' })
    }

    opts.innerHTML += data.label || ''

    return opts
  }
}

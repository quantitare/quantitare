import Icon from '../icon'

export default {
  formatData(data) {
    return data.map((grouping, idx) => {
      return {
        label: grouping.label,
        id: grouping.id,
        disabled: false,
        choices: grouping.places.map((place) => {
          return {
            value: place.id,
            label: place.name,
            customProperties: { icon: place.icon, category: place.category }
          }
        })
      }
    })
  },

  formatItem: (data) => {
    const opts = { innerHTML: '' }

    if (data.customProperties.icon) {
      opts.innerHTML += Icon
        .build(data.customProperties.icon)
        .tag(
          { size: 'sm_dark', className: 'mr-2', height: 18, width: 18 }
        )
    }

    opts.innerHTML += data.label || ''
    opts.innerHTML += ` <small class="text-muted">${data.customProperties.category}</small>`

    return opts
  },

  formatSelect: (data) => {
    let icon = ''

    if (data.customProperties.icon) {
      icon = Icon.build(data.customProperties.icon).tag(
        { size: 'sm_dark', height: 18, width: 18 }
      )
    }

    return {
      innerHTML: `
        <div class="row">
          <div class="col-1">${icon}</div>

          <div class="col-11">
            ${data.label}<br>

            <small class="text-muted">${data.customProperties.category}</small>
          </div>
        </div>
      `
    }
  }
}

import S from 'string'

export default class Scrobbler {
  get friendlyType() {
    return S(this.type.replace(/^.*::/, '')).humanize().titleCase().s
  }
}

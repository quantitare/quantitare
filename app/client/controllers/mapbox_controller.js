import { Controller } from 'stimulus'
import mapboxgl from 'mapbox-gl'

mapboxgl.accessToken = process.env.MAPBOX_API_KEY

export default class extends Controller {
  static targets = ['map']

  connect() {
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/light-v10',

      bounds: this.previousBounds,
      maxZoom: 17,
    })

    this.map.on('load', () => {
      this.map.resize()
      this.renderLayers()
    })
  }

  disconnect() {
    this.map.remove()
  }

  renderLayers() {
    const places = this.fetchLocationScrobbles('place')
    const transits = this.fetchLocationScrobbles('transit')

    places.then((json) => this.populatePlaces(json))
    transits.then((json) => this.populateTransits(json))

    Promise.all([places, transits]).then((collections) => this.updateBounds(collections))
  }

  fetchLocationScrobbles(type) {
    return new Promise((resolve, reject) => {
      fetch(this.filteredScrobblesPath({ type: type }))
        .then((response) => response.json())
        .then((json) => resolve(json))
    })
  }

  populatePlaces(json) {
    this.map.addSource('place-scrobbles', { type: 'geojson', data: json })

    this.map.addLayer({
      id: 'place-scrobbles', type: 'circle', 'source': 'place-scrobbles',
      paint: {
        'circle-radius': 4,
        'circle-color': '#76B1E8',
        'circle-stroke-color': '#7876E8',
        'circle-stroke-width': 2,
        'circle-stroke-opacity': 0.25,
      }
    })
  }

  populateTransits(json) {
    this.map.addSource('transit-scrobbles', { type: 'geojson', data: json })

    this.map.addLayer({
      id: 'transit-scrobbles', type: 'line', source: 'transit-scrobbles',
      paint: {
        'line-color': ['get', 'colorPrimary'],
        'line-width': 3,
        'line-opacity': 0.45,
      }
    })
  }

  updateBounds(geojsonCollections) {
    const bounds = new mapboxgl.LngLatBounds()

    geojsonCollections.forEach((collection) => {
      collection.features.forEach((feature) => {
        bounds.extend(feature.geometry.coordinates)
      })
    })

    this.map.fitBounds(bounds, { padding: 80 })
    this.previousBounds = bounds
  }

  fitBounds() {
    const bounds = new mapboxgl.LngLatBounds()
    console.log(this.map.isSourceLoaded('transit-scrobbles'))
  }

  filteredScrobblesPath(filters) {
    const url = this.scrobblesPathURL

    for (const prop in filters) {
      url.searchParams.append(prop, filters[prop])
    }

    return url.href
  }

  get scrobblesPath() {
    return this.data.get('scrobbles-path')
  }

  get scrobblesPathURL() {
    return new URL(this.scrobblesPath)
  }

  get previousBounds() {
    const raw = JSON.parse(localStorage.getItem('mapBounds'))
    if (!raw) return undefined

    return new mapboxgl.LngLatBounds(
      new mapboxgl.LngLat(raw.sw.lng, raw.sw.lat),
      new mapboxgl.LngLat(raw.ne.lng, raw.sw.lat)
    )
  }

  set previousBounds(value) {
    const formatted = { sw: value['_sw'] || value['sw'], ne: value['_ne'] || value['ne'] }

    localStorage.setItem('mapBounds', JSON.stringify(formatted))
  }
}

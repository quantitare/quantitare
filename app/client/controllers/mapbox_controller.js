import { Controller } from 'stimulus'
import mapboxgl from 'mapbox-gl'

mapboxgl.accessToken = process.env.MAPBOX_API_KEY

export default class extends Controller {
  static targets = ['map']

  connect() {
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/light-v10',

      center: this.center,
      zoom: 14
    })

    this.map.on('load', () => {
      this.map.addSource('place-scrobbles', { type: 'geojson', data: this.scrobbles.geojson.places })

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

      this.map.addSource('transit-scrobbles', { type: 'geojson', data: this.scrobbles.geojson.transits })

      this.map.addLayer({
        id: 'transit-scrobbles', type: 'line', source: 'transit-scrobbles',
        paint: {
          'line-color': ['get', 'colorPrimary'],
          'line-width': 3,
          'line-opacity': 0.45,
        }
      })

      console.log(this.scrobbles.geojson.transits)
    })
  }

  disconnect() {
    this.map.remove()
  }

  get scrobbles() {
    return JSON.parse(this.data.get('scrobbles'))
  }

  get center() {
    const sums = this.scrobbles.scrobbles.reduce((accumulator, current) => {
      return { lat: accumulator.lat + current.averageLatitude, lon: accumulator.lon + current.averageLongitude }
    }, { lat: 0, lon: 0 })
    const length = this.scrobbles.scrobbles.length

    return [sums.lon / length, sums.lat / length]
  }
}

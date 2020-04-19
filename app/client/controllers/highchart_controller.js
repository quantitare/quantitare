import { Controller } from 'stimulus'
import Highcharts from 'highcharts'
import timeline from 'highcharts/modules/timeline'
import xrange from 'highcharts/modules/xrange'

timeline(Highcharts)
xrange(Highcharts)

export default class extends Controller {
  connect() {
    fetch(this.modulePath)
      .then((response) => response.json())
      .then((json) => { this.chart = Highcharts.chart(this.element, json.chartOptions) })
  }

  disconnect() {
    if (this.chart) this.chart.destroy()
  }

  get modulePath() {
    return this.data.get('path')
  }
}

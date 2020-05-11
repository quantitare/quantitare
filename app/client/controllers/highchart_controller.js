import { Controller } from 'stimulus'

import Highcharts from 'highcharts'
import timeline from 'highcharts/modules/timeline'
import xrange from 'highcharts/modules/xrange'

import { merge } from 'lodash'

timeline(Highcharts)
xrange(Highcharts)

export default class extends Controller {
  connect() {
    fetch(this.modulePath)
      .then((response) => response.json())
      .then((json) => { this.chart = Highcharts.chart(this.element, this.compileChartOptions(json.chartOptions)) })
  }

  disconnect() {
    if (this.chart) this.chart.destroy()
  }

  compileChartOptions(chartOptions) {
    return merge(chartOptions, this.handlers)
  }

  postprocessSeries(series) {
    series.points.forEach((point) => this.postprocessPoint(point))
  }

  postprocessPoint(point) {
    if (!point.qnOptions) return

    for (const prop in point.qnOptions.data) {
      point.graphic.element.dataset[prop] = point.qnOptions.data[prop]
    }
  }

  get modulePath() {
    return this.data.get('path')
  }

  get handlers() {
    const self = this

    return {
      chart: {
        events: {
          load: function() {
            this.series.forEach((series) => self.postprocessSeries(series))
          }
        }
      }
    }
  }
}

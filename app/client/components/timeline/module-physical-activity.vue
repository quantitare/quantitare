<template>
  <div>
    <div class="row">
      <div class="col">
        <highchart :options="chartOptions"></highchart>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <module-summary :totals="totals"></module-summary>
      </div>
    </div>
  </div>
</template>

<script>
import { Chart } from 'highcharts-vue'
import Highcharts from 'highcharts'
import xrange from 'highcharts/modules/xrange'

import _ from 'lodash'
import { Duration } from 'luxon'

import DateAndScale from 'mixins/date-and-scale'

xrange(Highcharts)

export default {
  mixins: [DateAndScale],

  components: {
    highchart: Chart
  },

  props: {
    id: Number
  },

  data() {
    return {
      datasets: {}
    }
  },

  computed: {
    chartOptions() {
      return {
        series: this.chartSeries,

        chart: {
          height: 175,
        },

        plotOptions: {
          column: {
            stacking: 'normal',
            pointWidth: 10,
            pointPlacement: 0.5,
          },

          xrange: {
            pointWidth: 10,
            pointPlacement: 0.5
          }
        },

        title: { text: undefined },
        legend: { enabled: false },
        time: { useUTC: false },

        xAxis: {
          type: 'datetime',
          min: this.startOfScale.toMillis(),
          max: this.endOfScale.toMillis(),
        },

        yAxis: [
          {
            min: 0,
            max: 5,
            labels: { enabled: false },
            title: { text: null },
            visible: false,
          },

          {
            min: 0,
            max: 2000,
            labels: { enabled: false },
            title: { text: null },
            visible: false,
          }
        ],
      }
    },

    chartSeries() {
      return (this.datasets.sleep || [])
        .concat(this.datasets.workouts || [])
        .concat(this.datasets.steps || [])
    },

    totals() {
      if (_.isEmpty(this.datasets)) return []

      return [
        {
          total: Math.round(_.sumBy(this.datasets.sleep[0].data, (data) => data.x2 - data.x) / 1000 / 60),
          unit: 'min',
          label: 'asleep'
        },

        {
          total: _.sumBy(this.datasets.steps[0].data, (data) => data.y),
          unit: null,
          label: 'steps'
        }
      ]
    },

    scrobblesPath() {
      return `/timeline/modules/${this.id}?scale=${this.scale}&date=${this.date}`
    },
  },

  methods: {
    formatDate(dateString) {
      return Date.parse(dateString)
    },

    formatDuration(milliseconds) {
      return Duration.fromMillis(milliseconds).toFormat('h s')
    }
  },

  created() {
    this.$http.get(this.scrobblesPath).then((response) => this.datasets = response.body.datasets)
  },
}
</script>

<style lang="scss">
.highcharts-credits { display: none; }
</style>

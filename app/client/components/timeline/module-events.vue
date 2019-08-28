<template>
  <div>
    <div class="row">
      <div class="col">
        <highchart
          v-for="dataset in datasetNames"
          :key="dataset"
          :options="chartOptions(dataset)"

          class="timeline-chart"
        >
        </highchart>
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
import timeline from 'highcharts/modules/timeline'
import _ from 'lodash'
import S from 'string'

import DateAndScale from 'mixins/date-and-scale'

timeline(Highcharts)

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
    scrobblesPath() {
      return `/timeline/modules/${this.id}?scale=${this.scale}&date=${this.date}`
    },

    datasetNames() {
      return _.keys(this.datasets)
    },

    totals() {
      return _.values(this.datasets).map((dataset) => {
        return {
          total: dataset[0].data.length,
          unit: null,
          label: S(dataset[0].name).capitalize().s
        }
      })
    },
  },

  methods: {
    chartOptions(dataset) {
      return {
        series: this.chartSeries(dataset),

        chart: {
          height: 30,
          backgroundColor: 'rgba(255, 255, 255, 0)',
        },

        plotOptions: {
          timeline: {
            dataLabels: { enabled: false },
            lineWidth: 0,

            tooltip: {
              pointFormat: `<span class="timeline-tooltip-body">{point.description}</span>`
            }
          },
        },

        title: { text: undefined },
        legend: { enabled: false },
        time: { useUTC: false },

        xAxis: {
          type: 'datetime',
          min: this.startOfScale.toMillis(),
          max: this.endOfScale.toMillis(),
          visible: false,
        },

        yAxis: [
          {
            labels: { enabled: false },
            title: { text: null },
            visible: false,
          }
        ],
      }
    },

    chartSeries(dataset) {
      return (this.datasets[dataset] || [])
    },

    formatDate(dateString) {
      return Date.parse(dateString)
    },
  },

  created() {
    this.$http.get(this.scrobblesPath).then((response) => this.datasets = response.body.datasets)
  },
}
</script>

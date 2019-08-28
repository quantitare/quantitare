<template>
  <div class="row">
    <div class="col">
      <highchart :options="chartOptions"></highchart>
    </div>
  </div>
</template>

<script>
import { Chart } from 'highcharts-vue'
import _ from 'lodash'

import DateAndScale from 'mixins/date-and-scale'


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
            max: 150,
            labels: { enabled: false },
            title: { text: null },
            visible: false,
          }
        ],
      }
    },

    chartSeries() {
      return this.datasets.heart_rate || []
    },

    scrobblesPath() {
      return `/timeline/modules/${this.id}?scale=${this.scale}&date=${this.date}`
    },
  },

  methods: {
    formatDate(dateString) {
      return Date.parse(dateString)
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

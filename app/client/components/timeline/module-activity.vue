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
      datasets: {},
      deviceCategories: ['Very productive', 'Productive', 'Neutral', 'Unproductive', 'Very unproductive'],
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
            pointWidth: 10
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
            max: 15,
            labels: { enabled: false },
            title: { text: null },
            visible: false,
          }
        ],
      }
    },

    chartSeries() {
      const deviceDataset = this.datasets.device_activity || []
      return _.sortBy(deviceDataset, (data) => this.deviceCategories.indexOf(data.name))
    },

    totals() {
      return this.chartSeries.map((dataset) => {
        return {
          total: Math.round(_.sumBy(dataset.data, (data) => data.y)),
          unit: 'min',
          label: dataset.name
        }
      })
    },

    scrobblesPath() {
      return `/timeline/modules/${this.id}?scale=${this.scale}&date=${this.date}`
    },

    minDate() {
      return null;
    },

    maxDate() {
      return null;
    }
  },

  methods: {
    formatDate(dateString) {
      return Date.parse(dateString)
    }
  },

  created() {
    this.$http.get(this.scrobblesPath).then((response) => this.datasets = response.body.datasets)
  }
}
</script>

<style lang="scss">
.highcharts-credits { display: none; }
</style>

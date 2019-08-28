import { DateTime, Duration } from 'luxon'

export default {
  props: {
    scale: String,
    date: String
  },

  computed: {
    formattableDate() {
      return DateTime.fromISO(this.date)
    },

    startOfScale() {
      return this.formattableDate.startOf(this.scale)
    },

    endOfScale() {
      return this.formattableDate.endOf(this.scale)
    },

    prevDate() {
      return this.startOfScale.minus({ seconds: 1 })
    },

    nextDate() {
      return this.endOfScale.plus({ seconds: 1 })
    },

    scaleDuration() {
      return Duration.fromObject({ [`${this.scale}s`]: 1 })
    },
  }
}

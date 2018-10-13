import { DateTime, Interval } from 'luxon';

export default class LocationScrobble {
  get startAt() {
    return DateTime.fromISO(this.startTime);
  }

  get endAt() {
    return DateTime.fromISO(this.endTime);
  }

  get startAtDisplay() {
    return this.startAt.toLocaleString(DateTime.DATETIME_SHORT);
  }

  get endAtDisplay() {
    return this.endAt.toLocaleString(DateTime.DATETIME_SHORT);
  }

  get duration() {
    return this.endAt.diff(this.startAt, ['days', 'hours', 'minutes']);
  }

  get durationDisplay() {
    const components = [];

    if (this.duration.days) components.push(`${Math.round(this.duration.days)} days`);
    if (this.duration.hours) components.push(`${Math.round(this.duration.hours)} hr`);
    if (this.duration.minutes) components.push(`${Math.round(this.duration.minutes)} min`);

    return _.join(components, ' ');
  }

  get interval() {
    return Interval.fromDateTimes(this.startAt, this.endAt);
  }

  get daysSpanned() {
    const dates = [];

    let currentDateTime = this.startAt;
    while (currentDateTime.startOf('day') <= this.endAt.startOf('day')) {
      dates.push(currentDateTime.startOf('day'));
      currentDateTime = currentDateTime.plus({ days: 1 });
    }

    return dates;
  }

  get daySplitSegments() {
    return this.interval.splitAt(...this.daysSpanned.splice(1, this.daysSpanned.length - 1));
  }
}

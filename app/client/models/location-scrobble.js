import { DateTime } from 'luxon';

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
}

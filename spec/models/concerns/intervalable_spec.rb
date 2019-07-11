# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Intervalable do
  subject { c = Class.new { include Intervalable } }

  describe '#batch_intervals_by' do
    it 'sets the proper variable' do
      subject.batch_intervals_by(:foo)

      expect(subject.interval_batch_scale).to eq(:foo)
    end
  end

  describe '#normalize_times' do
    it 'returns a list of times by default' do
      t1 = Time.current
      t2 = 5.minutes.from_now

      expect(subject.normalize_times(t1, t2)).to contain_exactly(t1, t2)
    end

    it 'returns a list of dates when the interval_batch_scale is :date' do
      subject.batch_intervals_by(:date)

      expect(subject.normalize_times(5.days.ago, Time.current).all? { |t| t.is_a?(::Date) }).to be(true)
    end
  end

  describe '#normalize_time' do
    it 'returns a time by default' do
      expect(subject.normalize_time(Time.current)).to be_a(::Time)
    end

    it 'returns a date if the interval_batch_scale is :date' do
      subject.batch_intervals_by(:date)

      expect(subject.normalize_time(Time.current)).to be_a(::Date)
    end
  end

  describe '#denormalize_times' do
    it 'returns a list of times by default' do
      expect(subject.denormalize_times(Time.current, 5.minutes.from_now).all? { |t| t.is_a?(::Time) }).to be(true)
    end

    it 'returns a times if given dates while interval_batch_scale is :date' do
      subject.batch_intervals_by(:date)

      expect(
        subject.denormalize_times(Time.current.to_date, 5.days.from_now.to_date).all? { |t| t.is_a?(::Time) }
      ).to be(true)
    end

    it 'returns a span of times covering all times in the day if the interval_batch_scale is :date' do
      subject.batch_intervals_by(:date)
      t1 = Time.current.middle_of_day
      t2 = 5.days.from_now.middle_of_day

      d1, d2 = subject.denormalize_times(t1.to_date, t2.to_date)

      expect(d1..d2).to cover(t1..t2)
    end
  end
end

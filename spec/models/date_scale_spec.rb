require 'rails_helper'

RSpec.describe DateScale do
  describe '#beginning_of_scale' do
    it 'is the right date for the "day" scale' do
      expect(described_class.new(Date.current, 'day').from).to eq(Date.current.beginning_of_day)
    end

    it 'is the right date for the "week" scale' do
      expect(described_class.new(Date.current, 'week').from).to eq(Date.current.beginning_of_week)
    end

    it 'is the right date for the "month" scale' do
      expect(described_class.new(Date.current, 'month').from).to eq(Date.current.beginning_of_month)
    end

    it 'is the right date for the "year" scale' do
      expect(described_class.new(Date.current, 'year').from).to eq(Date.current.beginning_of_year)
    end

    it 'throws when you give it an invalid scale' do
      expect { described_class.new(Date.current, 'foo').from }.to raise_error(DateScale::InvalidScaleError)
    end
  end

  describe '#end_of_scale' do
    it 'is the right date for the "day" scale' do
      expect(described_class.new(Date.current, 'day').to).to eq(Date.current.end_of_day)
    end

    it 'is the right date for the "week" scale' do
      expect(described_class.new(Date.current, 'week').to).to eq(Date.current.end_of_week)
    end

    it 'is the right date for the "month" scale' do
      expect(described_class.new(Date.current, 'month').to).to eq(Date.current.end_of_month)
    end

    it 'is the right date for the "year" scale' do
      expect(described_class.new(Date.current, 'year').to).to eq(Date.current.end_of_year)
    end

    it 'throws when you give it an invalid scale' do
      expect { described_class.new(Date.current, 'foo').to }.to raise_error(DateScale::InvalidScaleError)
    end
  end

  describe '#previous_date' do
    it 'is the previous day on the "day" scale' do
      expect(described_class.new(Date.current, 'day').previous_date).to eq(Date.yesterday)
    end

    it 'is the last day of the previous week on the "week" scale' do
      expect(described_class.new(Date.current, 'week').previous_date).to eq(Date.current.beginning_of_week - 1)
    end

    it 'is the last day of the previous month on the "month" scale' do
      expect(described_class.new(Date.current, 'month').previous_date).to eq(Date.current.beginning_of_month - 1)
    end

    it 'is the last day of the previous year on the "year" scale' do
      expect(described_class.new(Date.current, 'year').previous_date).to eq(Date.current.beginning_of_year - 1)
    end

    it 'throws when you give it an invalid scale' do
      expect { described_class.new(Date.current, 'foo').previous_date }.to raise_error(DateScale::InvalidScaleError)
    end
  end

  describe '#next_date' do
    it 'is the next day on the "day" scale' do
      expect(described_class.new(Date.current, 'day').next_date).to eq(Date.tomorrow)
    end

    it 'is the first day of the next week on the "week" scale' do
      expect(described_class.new(Date.current, 'week').next_date).to eq(Date.current.end_of_week + 1)
    end

    it 'is the first day of the next month on the "month" scale' do
      expect(described_class.new(Date.current, 'month').next_date).to eq(Date.current.end_of_month + 1)
    end

    it 'is the first day of the next year on the "year" scale' do
      expect(described_class.new(Date.current, 'year').next_date).to eq(Date.current.end_of_year + 1)
    end

    it 'throws when you give it an invalid scale' do
      expect { described_class.new(Date.current, 'foo').next_date }.to raise_error(DateScale::InvalidScaleError)
    end
  end
end

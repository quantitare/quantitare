require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for Scrobble do
  class Quantitare::Categories::ScrobbleTest < Quantitare::Category
    specification do
      required(:name).filled(:string)
    end
  end

  it_behaves_like HasGuid
  it_behaves_like Periodable
  it_behaves_like Categorizable

  it { should validate_presence_of :category }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  describe 'category validation' do
    before { subject.category = 'scrobble_test' }

    it 'is invalid if the data does not meet the category specification' do
      subject.data = { name: '' }

      subject.validate
      expect(subject.errors[:data]).to be_present
    end

    it 'is valid if the data meets the category specification' do
      subject.data = { name: 'some_name_1' }

      subject.validate
      expect(subject.errors[:data]).to_not be_present
    end
  end

  describe '#timestamp=' do
    it 'sets start_time and end_time automatically' do
      subject.timestamp = 5.minutes.ago

      expect(subject.start_time).to be_present
      expect(subject.end_time).to be_present
    end

    it 'changes start_time and end_time when it changes' do
      subject.timestamp = 1.year.ago

      expect(subject.start_time).to eq(subject.timestamp)
      expect(subject.end_time).to eq(subject.end_time)
    end

    it 'keeps it valid' do
      expect(subject).to be_valid
    end

    it 'persists start_time and end_time after saving' do
      subject.save!
      subject.reload

      expect(subject.start_time).to be_present
      expect(subject.end_time).to be_present
    end
  end

  describe '#timestamp' do
    it 'retrieves correctly after saving' do
      time = 1.day.ago
      subject.timestamp = time

      subject.save!
      subject.reload

      expect(subject.timestamp).to eq(time)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place, :vcr do
  subject { build :place }

  it { should have_db_index :user_id }

  it { should belong_to(:user) }
  it { should belong_to(:service) }
  it { should have_many(:location_scrobbles) }
  it { should have_many(:place_matches) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:category) }

  it_behaves_like HasGuid
  it_behaves_like Categorizable

  describe 'custom validations' do
    describe 'presence of address and coordinates' do
      it 'is invalid if neither are present' do
        expect(build :place, longitude: nil, latitude: nil).to be_invalid
      end
    end

    describe 'presence of coordinate components' do
      it 'is invalid if only latitude is present' do
        expect(build :place, longitude: nil).to be_invalid
      end

      it 'is invalid if only longitude is present' do
        expect(build :place, latitude: nil).to be_invalid
      end
    end
  end

  describe 'geocoding hooks' do
    it 'sets the address when created with coordinates' do
      subject.save!

      expect(subject.full_address).to be_present
    end

    context 'with an address provided' do
      subject { build :place, :starting_with_address }

      it 'sets coordinates' do
        subject.save!

        expect(subject.coordinates).to be_present
      end
    end
  end

  describe '#custom?' do
    it 'returns true with no service' do
      expect(subject.custom?).to be(true)
    end

    context 'with a service' do
      subject { build :place, :with_service }

      it 'returns false' do
        expect(subject.custom?).to be(false)
      end
    end
  end

  describe '#full_address' do
    it 'returns a blank string without any address attributes' do
      expect(subject.full_address).to be_blank
    end

    context 'with address fields listed' do
      subject { build :place, :starting_with_address }

      it 'returns a string with the details' do
        expect(subject.full_address).to be_present
      end
    end
  end

  describe '#full_address_changed?' do
    it 'returns false when none of the address fields have been set' do
      expect(subject.full_address_changed?).to be(false)
    end

    it 'returns true when we change the street' do
      subject.street_1 = '1 Frank H Ogawa Plaza'

      expect(subject.full_address_changed?).to be(true)
    end

    it 'returns true when we change the city' do
      subject.city = 'Oakland'

      expect(subject.full_address_changed?).to be(true)
    end

    it 'returns true when we change the state' do
      subject.state = 'CA'

      expect(subject.full_address_changed?).to be(true)
    end

    it 'returns true when we change the zip' do
      subject.zip = '94612'

      expect(subject.full_address_changed?).to be(true)
    end

    it 'returns true when we change the country' do
      subject.country = 'United States'

      expect(subject.full_address_changed?).to be(true)
    end
  end

  describe '#coordinates' do
    it 'has a filled array when the coordinates are set' do
      expect(subject.coordinates.compact).to be_present
    end

    it 'returns coordinates in the right order' do
      expect(subject.coordinates).to eq([subject.longitude, subject.latitude])
    end
  end

  describe '#coordinates_changed?' do
    it 'returns false on a freshly persisted record' do
      subject.save!

      expect(subject.coordinates_changed?).to be(false)
    end

    it 'returns true when we change the longitude' do
      subject.save!
      subject.longitude = 1

      expect(subject.coordinates_changed?).to be(true)
    end

    it 'returns true when we change the latitude' do
      subject.save!
      subject.latitude = 1

      expect(subject.coordinates_changed?).to be(true)
    end
  end
end

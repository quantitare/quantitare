# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationImport do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:adapter) }

  it { should belong_to(:user) }
  it { should have_many(:location_scrobbles) }

  it { should have_db_index :user_id }

  subject { build :location_import }

  it_behaves_like HasGuid

  describe '.adapters' do
    subject { LocationImport }

    let(:action) { subject.adapters }

    it 'is enumerable' do
      expect(action).to respond_to(:each)
    end
  end

  describe '.add_adapter' do
    let(:adapter) { Class.new }
    subject { LocationImport }

    let(:action) { subject.add_adapter(adapter) }

    it 'adds to adapters' do
      action

      expect(subject.adapters).to include(adapter)
    end
  end
end

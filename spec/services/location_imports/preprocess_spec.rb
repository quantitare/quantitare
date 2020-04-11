# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationImports::Preprocess do
  let(:location_import) { build :location_import, :with_file }
  let(:context) do
    LightService::Testing::ContextFactory
      .make_from(ProcessLocationImport)
      .for(described_class)
      .with(location_import, collision_mode: :keep_both)
  end

  describe '.execute' do
    let(:action) { described_class.execute(context) }

    it 'is successful' do
      expect(action).to be_success
    end

    it 'persists the LocationImport' do
      action

      expect(location_import).to be_persisted
    end

    it 'adds unpersisted scrobbles' do
      expect(action.location_scrobbles.any?(&:persisted?)).to be(false)
    end

    it 'adds scrobbles to the context' do
      expect(action.location_scrobbles).to be_present
    end

    context 'with an invalid LocationImport' do
      let(:location_import) { build :location_import, :with_file, user: nil }


      it 'fails the context' do
        expect(action).to_not be_success
      end

      it 'does not persist the LocationImport' do
        expect(action.location_import).to_not be_persisted
      end
    end
  end

  describe '.rollback' do
    let(:action) do
      described_class.execute(context)
      described_class.rollback(context)
    end

    it 'destroys the LocationImport' do
      action

      expect(location_import).to be_destroyed
    end
  end
end

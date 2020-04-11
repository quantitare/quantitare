# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationImports::Postprocess do
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

    it 'persists the import' do
      expect(action.location_import).to_not be_changed
    end

    it 'fails when the save fails' do
      context.location_import.user = nil

      expect(action).to_not be_success
    end
  end
end

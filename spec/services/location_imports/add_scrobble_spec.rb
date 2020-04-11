require 'rails_helper'

RSpec.describe LocationImports::AddScrobble do
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

    it 'adds a scrobble to the LocationImport' do
      expect { action }.to change(location_import.location_scrobbles, :size).by(1)
    end

    it 'sets the user on the scrobble' do
      expect(action.location_scrobble.user).to eq(location_import.user)
    end
  end

  describe '.rollback' do
    let(:action) do
      described_class.execute(context)
      described_class.rollback(context)
    end

    it 'destroys the scrobble' do
      expect(action.location_scrobble).to be_destroyed
    end
  end
end

require 'rails_helper'

RSpec.describe WithingsAdapter::ServiceRefresh do
  let(:service) { create :service, :withings2, :expired }
  subject { WithingsAdapter::ServiceRefresh.new(service) }

  describe '#process!', :vcr do
    let(:action) { subject.process! }

    it 'runs without issues' do
      action

      expect(service.issues?).to be(false)
    end

    it "updates the service's token" do
      expect { action }.to change(service, :token)
    end

    it "updates the service's expiry date" do
      expect { action }.to change(service, :expires_at)
    end

    context 'when the given token is invalid' do
      let(:service) { create :service, :withings2, :expired, refresh_token: 'some_nonsense' }

      it 'raises a service config error' do
        expect { action }.to raise_error(Errors::ServiceConfigError)
      end
    end
  end
end

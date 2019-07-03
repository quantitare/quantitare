# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::Sample do
  describe '#data' do
    it 'raises a NotImplementedError' do
      expect { WithingsAdapter::Sample.new(nil, nil, nil, nil).data }.to raise_error(NotImplementedError)
    end
  end
end

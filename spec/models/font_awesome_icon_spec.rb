# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FontAwesomeIcon do
  subject { described_class.new(name: 'fas fa-plus') }

  it_behaves_like Icon
end

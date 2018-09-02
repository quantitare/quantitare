# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service do
  it { should belong_to(:user) }
  it { should have_many(:scrobblers) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:token) }
end

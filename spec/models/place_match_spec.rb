require 'rails_helper'

RSpec.describe PlaceMatch do
  it { should belong_to(:user) }
  it { should belong_to(:source) }
  it { should belong_to(:place) }
end

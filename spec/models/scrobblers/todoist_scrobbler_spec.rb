# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::TodoistScrobbler, :vcr do
  subject { create :todoist_scrobbler }

  it_behaves_like 'fetchable_scrobbler', Time.zone.parse('2019-07-18 00:00:00'), Time.zone.parse('2019-07-19 00:00:00')
end

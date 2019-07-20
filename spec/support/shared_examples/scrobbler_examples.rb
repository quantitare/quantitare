# frozen_string_literal: true

require 'rails_helper'

# Requires in scope: subject (the scrobbler) and action (the #fetch_and_format_scrobbles call)
RSpec.shared_examples 'fetchable_scrobbler' do
  it 'returns a non-blank list' do
    expect(action).to_not be_blank
  end

  it 'returns all valid scrobbles' do
    expect(action.all? { |scrobble| scrobble.valid? }).to be(true)
  end

  it 'attributes all scrobbles to the scrobbler' do
    expect(action.all? { |scrobble| scrobble.source == subject }).to be(true)
  end

  it 'attributes all scrobbles to the user' do
    expect(action.all? { |scrobble| scrobble.user == subject.user }).to be(true)
  end
end

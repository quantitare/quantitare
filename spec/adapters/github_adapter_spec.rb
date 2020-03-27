# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubAdapter, :vcr do
  let(:service) { create :service, :github }

  subject { GithubAdapter.new(service) }

  describe '#fetch_scrobbles' do
    let(:start_time) { Time.zone.parse('2020-03-25') }
    let(:end_time) { Time.zone.parse('2020-03-28') }
    let(:action) { subject.fetch_scrobbles start_time, end_time }

    it 'returns a list' do
      expect(action).to be_an(Array)
    end

    it 'returns a list of Scrobble objects' do
      expect(action.all? { |item| item.is_a?(Scrobble) }).to be(true)
    end

    it 'returns everything unpersisted' do
      expect(action.none? { |item| item.persisted? }).to be(true)
    end

    it 'has start_times and end_times for each returned scrobble' do
      expect(action.all? { |item| item.start_time.present? && item.end_time.present? }).to be(true)
    end

    it 'returns valid data for each returned scrobble' do
      expect(
        action.all? do |item|
          item.validate
          item.errors[:data].blank?
        end
      ).to be(true)
    end

    it 'returns all scrobbles between the specified times' do
      expect(action.all? { |item| item.timestamp.in?(start_time..end_time) }).to be(true)
    end
  end

  describe '#fetch_code_commit' do
    it 'can fetch a commit for a public repo' do
      expect(
        subject.fetch_code_commit(
          repository_name: 'aastronautss-dev/quantitare-test-public',
          sha: '80d582136b4447a6cb31dbab7f018327552e7730'
        )
      ).to be_an(Aux::CodeCommit)
    end

    it 'can fetch a commit for a private repo' do
      expect(
        subject.fetch_code_commit(
          repository_name: 'aastronautss-dev/quantitare-test-private',
          sha: '13e4d6e8284d13f0cc80288365d96cbaafac0288'
        )
      ).to be_an(Aux::CodeCommit)
    end
  end
end

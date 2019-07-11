# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::RequestCompiler do
  subject { WithingsAdapter::RequestCompiler.new(24.hours.ago, 1.hour.ago) }

  describe '#each' do
    it 'can be passed a block' do
      subject << 'sleep'

      subject.each { |item| expect(item).to be_a(WithingsAdapter::Request) }
    end
  end

  describe '#<<' do
    it 'adds a Request object to the items' do
      subject << 'sleep'

      expect(subject.first).to be_a(WithingsAdapter::Request)
    end
  end
end

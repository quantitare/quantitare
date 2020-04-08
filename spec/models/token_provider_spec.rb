# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenProvider do
  subject do
    TokenProvider.new(
      'my_provider',
      fields: { token: { as: :key } },
      icon_css_class: 'my-provider',
      icon_text_color: '#fff',
      icon_bg_color: '#000'
    )
  end

  describe '#oauth?' do
    it 'is false' do
      expect(subject.oauth?).to be(false)
    end
  end

  describe '#fields' do
    it 'passes the correct value' do
      expect(subject.fields[:token]).to eq(as: :key)
    end
  end

  describe '#icon' do
    it 'is a correctly formatted hash' do
      expect(subject.icon).to have_key(:type)
    end
  end

  describe '#icon_text_color' do
    it 'passes the correct value through' do
      expect(subject.icon_text_color).to eq('#fff')
    end
  end

  describe '#icon_bg_color' do
    it 'passes the correct value through' do
      expect(subject.icon_bg_color).to eq('#000')
    end
  end

  describe '#icon_css_class' do
    it 'passes the correct value through' do
      expect(subject.icon_css_class).to eq('my-provider')
    end
  end
end

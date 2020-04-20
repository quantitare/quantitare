# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Icon do
  describe '.for' do
    it 'returns a FontAwesome icon when passed the right key' do
      expect(described_class.for(:fa, name: 'fas fa-plus')).to be_a(FontAwesomeIcon)
    end

    it 'returns an image icon when passed the right key' do
      expect(described_class.for(:img, xl: '/some/img.png')).to be_a(ImageIcon)
    end

    it 'throws if we give it an invalid type' do
      expect { described_class.for(:foo) }.to raise_error(Icon::InvalidTypeError)
    end
  end
end

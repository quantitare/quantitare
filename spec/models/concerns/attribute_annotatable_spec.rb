# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttributeAnnotatable do
  with_model :Thing do
    table do |t|
      t.string :name
      t.string :type

      t.jsonb :options
      t.jsonb :settings

      t.timestamps

      t.index :options, using: :gin
    end

    model do
      include AttributeAnnotatable

      jsonb_accessor :options,
        widget: :string,
        gadgets: [:string, array: true],
        number: [:integer, display: { help: 'Something' }],
        stuff: :json

      jsonb_accessor :settings,
        other_thing: :string
    end
  end

  describe '#attribute_annotation_for' do
    it 'has keys for each jsonb accessor' do
      expect(Thing.new.attribute_annotation_for(:options).keys).to contain_exactly(:widget, :gadgets, :number, :stuff)
    end

    it 'sets the type for a non-array type' do
      expect(Thing.new.attribute_annotation_for(:options).dig(:widget, :type)).to eq(:string)
    end

    it 'does not set a subtype for a non-array type' do
      expect(Thing.new.attribute_annotation_for(:options).dig(:widget, :subtype)).to be_nil
    end

    it 'sets a proper type for an array type' do
      expect(Thing.new.attribute_annotation_for(:options).dig(:gadgets, :type)).to eq(:array)
    end

    it 'sets the right subtype for an array type' do
      expect(Thing.new.attribute_annotation_for(:options).dig(:gadgets, :subtype)).to eq(:string)
    end

    it 'sets the "display" attribute where given' do
      expect(Thing.new.attribute_annotation_for(:options).dig(:number, :display)).to have_key(:help)
    end
  end
end

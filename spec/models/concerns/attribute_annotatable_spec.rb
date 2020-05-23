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
      include AttrJson::Record
      include AttributeAnnotatable

      attr_json_config default_container_attribute: :options

      attr_json :widget, :string
      attr_json :gadgets, :string, array: true
      attr_json :number, :integer, display: { help: 'Something' }
      attr_json :stuff, :json

      attr_json :other_thing, :string, container_attribute: :settings
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

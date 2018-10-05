require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for Categorizable do
  describe '.category_attribute' do
    it 'is not nil' do
      expect(subject.class.category_attribute).to_not be_nil
    end
  end

  describe '#category_klass' do
    it 'exists' do
      expect(subject.category_klass).to be_present
    end

    it 'is a module' do
      expect(subject.category_klass).to be_a(Module)
    end
  end

  describe '#category_info' do
    it 'returns something that has a name' do
      expect(subject.category_info).to respond_to(:name)
    end

    it 'returns something that has an icon' do
      expect(subject.category_info).to respond_to(:icon)
    end
  end

  describe '#category_name' do
    it 'returns a string' do
      expect(subject.category_name).to be_a(String)
    end
  end

  describe '#category_icon' do
    it 'returns a hash' do
      expect(subject.category_icon).to be_a(Hash)
    end
  end
end

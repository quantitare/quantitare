shared_examples LocationCategory do
  describe '#icon' do
    it 'converts a hash to an Icon instance' do
      icon = { type: :fa, name: 'fas fa-plus' }

      expect(described_class.new('Business', icon: icon).icon).to be_an(Icon)
    end

    it 'passes an Icon instance through' do
      icon = Icon.for(:fa, name: 'fas fa-plus')

      expect(described_class.new('Business', icon: icon).icon).to eq(icon)
    end
  end

  describe '#to_h' do
    it 'sets :icon to a hash' do
      category = described_class.new('Business', icon: Icon.for(:fa, name: 'fas fa-plus'))

      expect(category.to_h[:icon]).to be_a(Hash)
    end
  end
end

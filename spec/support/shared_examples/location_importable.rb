shared_examples LocationImportable do
  describe '.importer_label' do
    it 'is a string' do
      expect(described_class.importer_label).to be_a(String)
    end
  end
end

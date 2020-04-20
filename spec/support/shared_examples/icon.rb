# frozen_string_literal: true

shared_examples Icon do
  describe '#to_h' do
    it 'is a hash' do
      expect(subject.to_h).to be_a(Hash)
    end
  end
end

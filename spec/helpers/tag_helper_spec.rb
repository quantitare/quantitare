# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagHelper do
  describe '#icon_tag' do
    it 'can be passed a FontAwesome icon' do
      expect(helper.icon_tag(Icon.for(:fa, name: 'fas fa-plus'))).to start_with('<i class="fas')
    end

    it 'can be passed an image icon' do
      expect(helper.icon_tag(Icon.for(:img, xl: '/some/img.png'))).to start_with('<img src="/some/img.png')
    end
  end

  describe '#fa_icon_tag' do
    it 'returns the correct tag' do
      expect(helper.fa_icon_tag('fas fa-plus')).to start_with('<i class="fas')
    end
  end

  describe '#form_group_tag' do
    it 'returns something with the form-group class' do
      expect(helper.form_group_tag).to match(/form-group/)
    end

    it 'can receive additional classes' do
      expect(helper.form_group_tag(class: 'foo') { 'hello' }).to match(/class=\"form-group foo\"/)
    end

    it 'yields' do
      expect(helper.form_group_tag { 'hello' }).to match(/hello/)
    end
  end
end

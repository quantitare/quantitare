# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#model_url_for' do
    it 'returns the proper URL for a normal model' do
      expect(helper.model_url_for(create(:service))).to match(/\A\/service/)
    end

    it 'returns the proper URL for a decorated model' do
      expect(helper.model_url_for(create(:service).decorate)).to match(/\A\/service/)
    end

    it 'excludes the type-specific url for a STI object' do
      expect(helper.model_url_for(create(:webhook_scrobbler))).to match(/\A\/scrobbler/)
    end
  end

  describe '#badge_tag' do
    it 'includes the content' do
      expect(helper.badge_tag('some content')).to include('some content')
    end

    it 'has a badge class' do
      expect(helper.badge_tag('some content')).to include('class="badge badge-secondary"')
    end
  end
end

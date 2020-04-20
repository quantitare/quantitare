# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#add_dom_classes' do
    it 'returns a single class' do
      expect(helper.add_dom_classes('foo')).to eq('foo')
    end

    it 'dedupes classes from the first argument' do
      expect(helper.add_dom_classes('foo foo')).to eq('foo')
    end

    it 'adds two classes together when passed single classes as separate arguments' do
      expect(helper.add_dom_classes('foo', 'bar')).to eq('foo bar')
    end

    it 'adds two classes together when passed multiple classes as separate arguments' do
      expect(helper.add_dom_classes('foo', 'bar baz')).to eq('foo bar baz')
    end

    it 'adds several single classes together when passed several arguments' do
      expect(helper.add_dom_classes('foo', 'bar', 'baz')).to eq('foo bar baz')
    end

    it 'dedupes duplicated classes when passed several arguments' do
      expect(helper.add_dom_classes('foo', 'bar foo', 'bar baz')).to eq('foo bar baz')
    end

    it 'can be passed an array after the first argument' do
      expect(helper.add_dom_classes('foo', ['bar', 'baz'])).to eq('foo bar baz')
    end

    it 'can be passed a sparse array after the first argument' do
      expect(helper.add_dom_classes('foo', [nil, 'bar'])).to eq('foo bar')
    end
  end

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

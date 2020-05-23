require 'rails_helper'

RSpec.describe Templatable do
  class Scrobblers::TemplatableScrobbler < Scrobbler
    include Templatable

    attr_json :name, :string
  end

  let(:templatable) { Scrobblers::TemplatableScrobbler.new }

  describe '#template_context' do
    it 'behaves like a hash' do
      expect(templatable.template_context).to respond_to(:[])
    end

    it 'behaves like an assignable hash' do
      expect(templatable.template_context).to respond_to(:[]=)
    end

    it 'has an environments stack' do
      expect(templatable.template_context).to respond_to(:environments)
    end

    it 'has an enumerable environments stack' do
      expect(templatable.template_context.environments).to respond_to(:each)
    end
  end

  describe '#template_with' do
    it 'does not alter the template by default' do
      initial_stack_size = templatable.template_context.environments.length

      templatable.template_with { expect(templatable.template_context.environments.length).to eq(initial_stack_size) }
    end

    it 'does not alter the template if the given argument is not droppable' do
      initial_stack_size = templatable.template_context.environments.length
      the_object = double 'the_object'

      expect(the_object).to_not respond_to(:to_liquid) # sanity check
      templatable.template_with(the_object) do
        expect(templatable.template_context.environments.length).to eq(initial_stack_size)
      end
    end

    it 'adds the given object to the environment stack if the given argument is droppable' do
      initial_stack_size = templatable.template_context.environments.length
      liquid_drop = double 'liquid_drop'
      the_object = double 'the_object', to_liquid: liquid_drop

      templatable.template_with(the_object) do
        expect(templatable.template_context.environments.first).to eq(liquid_drop)
      end
    end

    it 'removes the given object from the environment stack after yielding' do
      initial_stack_size = templatable.template_context.environments.length
      liquid_drop = double 'liquid_drop'
      the_object = double 'the_object', to_liquid: liquid_drop

      templatable.template_with(the_object) {}
      expect(templatable.template_context.environments).to_not include(liquid_drop)
    end

    it 'adds the properties correctly to the templating scope' do
      result = templatable.template_with({ subject: 'world' }) do
        templatable.template_object 'hello, {{ subject }}'
      end

      expect(result).to eq('hello, world')
    end

    it 'can be nested' do
      result = templatable.template_with({ subject: 'dude' }) do
        templatable.template_with({ greeting: 'sup' }) do
          templatable.template_object '{{ greeting }}, {{ subject }}'
        end
      end

      expect(result).to eq('sup, dude')
    end
  end

  describe '#template_object' do
    around { |example| templatable.template_with({ subject: 'friend', greeting: 'hi' }) { example.run } }

    it 'interpolates on a string' do
      expect(templatable.template_object('{{ greeting }}, {{ subject }}')).to eq('hi, friend')
    end

    it 'interpolates on a hash' do
      expect(templatable.template_object({ thing: '{{ subject }}', salutation: '{{ greeting }}' })).to(
        eq({ thing: 'friend', salutation: 'hi' }.with_indifferent_access)
      )
    end

    it 'interpolates a collection' do
      expect(templatable.template_object(['{{ greeting }}', '{{ subject }}'])).to contain_exactly('hi', 'friend')
    end

    it 'does not interpolate a non-interpolable object' do
      object = double 'object'
      expect(templatable.template_object(object)).to eq(object)
    end
  end

  describe '#templated' do
    let(:name) { 'the {{ thing }}' }

    before { templatable.name = name }

    it 'behaves like a hash' do
      expect(templatable.templated).to respond_to(:[])
    end

    it 'sets the proper values from the template context' do
      templatable.template_with({ thing: 'monster' }) do
        expect(templatable.templated['name']).to eq('the monster')
      end
    end
  end
end

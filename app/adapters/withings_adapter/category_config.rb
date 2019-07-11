# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class CategoryConfig
    class << self
      def all
        CATEGORY_CONFIGS
      end

      def for_category(category)
        new(all[category.to_s])
      end

      def for_category_and_endpoint(category, endpoint)
        for_category(category).for_endpoint(endpoint)
      end
    end

    delegate :each, :[], :map, to: :configs

    attr_reader :configs

    def initialize(configs)
      @configs = configs
    end

    def for_endpoint(endpoint)
      path, action = endpoint

      configs.find { |config| config[:path] == path && config[:params][:action] == action }
    end
  end
end

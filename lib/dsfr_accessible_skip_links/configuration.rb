# frozen_string_literal: true

module DsfrAccessibleSkipLinks
  class Configuration
    attr_accessor :whitelisted_routes, :disable_validation

    def initialize
      @whitelisted_routes = []
      @disable_validation = false
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

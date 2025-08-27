# frozen_string_literal: true

module DsfrAccessibleSkipLinks
  class Engine < ::Rails::Engine
    isolate_namespace DsfrAccessibleSkipLinks

    config.to_prepare do
      ApplicationController.include(DsfrAccessibleSkipLinks::SkipLinks) if defined?(ApplicationController)
    end
  end
end

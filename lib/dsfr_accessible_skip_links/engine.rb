# frozen_string_literal: true

module DsfrAccessibleSkipLinks
  class Engine < ::Rails::Engine
    isolate_namespace DsfrAccessibleSkipLinks

    initializer "dsfr_accessible_skip_links.view_paths" do
	    ActiveSupport.on_load(:action_controller) do
		    prepend_view_path Engine.root.join("app", "views")
	    end

	    ActiveSupport.on_load(:action_mailer) do
		    prepend_view_path Engine.root.join("app", "views")
	    end
    end

    config.to_prepare do
      ApplicationController.include(DsfrAccessibleSkipLinks::SkipLinks) if defined?(ApplicationController)
    end
  end
end

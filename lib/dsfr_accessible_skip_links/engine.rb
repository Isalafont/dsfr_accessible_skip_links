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

    # Ensure helpers are available automatically in controllers and views
    initializer "dsfr_accessible_skip_links.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include DsfrAccessibleSkipLinks::SkipLinks
        helper DsfrAccessibleSkipLinks::SkipLinks if respond_to?(:helper)
      end

      ActiveSupport.on_load(:action_view) do
        include DsfrAccessibleSkipLinks::SkipLinks
      end
    end
  end
end

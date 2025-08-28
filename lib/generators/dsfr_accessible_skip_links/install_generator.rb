# frozen_string_literal: true

require "rails/generators"

module DsfrAccessibleSkipLinks
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc(
        "Installs DsfrAccessibleSkipLinks by copying the skip links partial. " \
        "No manual controller configuration is needed; helpers are auto-included."
      )
      def copy_partial
        copy_file "_skip_links.html.erb", "app/views/shared/_skip_links.html.erb"
      end

      # For backward compatibility, provide an optional injection step disabled by default.
      class_option :inject_layout, type: :boolean, default: false,
                                   desc: "Also inject <%= render 'shared/skip_links' %> into application layout"

      def inject_into_layout
        return unless options[:inject_layout]

        layout_path = "app/views/layouts/application.html.erb"
        return unless File.exist?(layout_path)
        return if layout_contains_render?(layout_path)

        if layout_has_body_tag?(layout_path)
          insert_render_after_body(layout_path)
        else
          prepend_render_to_layout(layout_path)
        end
      end

      def readme
        say <<~MSG
          DsfrAccessibleSkipLinks installed successfully!

          📁 Files created:
             • app/views/shared/_skip_links.html.erb (skip links partial)

          🔧 Next steps:
             1. Add <%= render 'shared/skip_links' %> to your layout file (typically app/views/layouts/application.html.erb)
                Place it right after the <body> tag for best accessibility.

             2. Ensure your layout has these elements with IDs:
                • #header (main navigation)
                • #content (main content area)  
                • #footer (page footer)

          💡 Quick setup option:
             Run `bin/rails g dsfr_accessible_skip_links:install --inject-layout` to automatically
             add the render call to your application layout.

          ℹ️  Helpers are automatically available in all controllers and views.
        MSG
      end

      private

      def layout_contains_render?(layout_path)
        content = File.read(layout_path)
        content.include?("render partial: 'shared/skip_links'") ||
          content.include?("render 'shared/skip_links'")
      end

      def layout_has_body_tag?(layout_path)
        File.read(layout_path) =~ /<body[^>]*>/
      end

      def insert_render_after_body(layout_path)
        render_snippet = "    <%= render 'shared/skip_links' %>\n"
        insert_into_file layout_path, after: /<body[^>]*>\s*\n?/ do
          render_snippet
        end
      end

      # If <body> tag is not found, append at the beginning of the file as a fallback
      def prepend_render_to_layout(layout_path)
        render_snippet = "    <%= render 'shared/skip_links' %>\n"
        prepend_to_file layout_path, render_snippet
      end
    end
  end
end

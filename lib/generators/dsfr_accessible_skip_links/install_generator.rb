# frozen_string_literal: true

require "rails/generators"

module DsfrAccessibleSkipLinks
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc(
        "Installs DsfrAccessibleSkipLinks by copying the skip links partial " \
        "and injecting the render call into the application layout."
      )
      def copy_partial
        # Use copy_file instead of template to avoid evaluating ERB in the generator context
        copy_file "_skip_links.html.erb", "app/views/shared/_skip_links.html.erb"
      end

      # rubocop:disable Metrics/MethodLength
      def inject_into_layout
        layout_path = "app/views/layouts/application.html.erb"
        return unless File.exist?(layout_path)

        render_snippet = "    <%= render partial: 'shared/skip_links' %>\n"

        content = File.read(layout_path)
        if content.include?("render partial: 'shared/skip_links'") || content.include?("render 'shared/skip_links'")
          return
        end

        if content =~ /<body[^>]*>/
          insert_into_file layout_path, after: /<body[^>]*>\s*\n?/ do
            render_snippet
          end
        else
          # If <body> tag is not found, append at the beginning of the file as a fallback
          prepend_to_file layout_path, render_snippet
        end
      end
      # rubocop:enable Metrics/MethodLength

      def readme
        say <<~MSG
          DsfrAccessibleSkipLinks installed.

          - A copy of the skip links partial has been placed at app/views/shared/_skip_links.html.erb
          - Your application layout has been updated to render the skip links.

          Ensure your layout contains elements with ids: #header, #content, and #footer for the default links.
        MSG
      end
    end
  end
end

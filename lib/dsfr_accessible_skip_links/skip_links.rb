# frozen_string_literal: true

module DsfrAccessibleSkipLinks
  module SkipLinks
    TAB_PREFIX = "tab-"

    def skip_link(text, anchor)
      anchor_str = anchor.to_s
      content_tag(:li) do
        if anchor_str.start_with?(TAB_PREFIX)
          link_to(text, "##{anchor_str}", class: "fr-link", data: { anchor: anchor_str })
        else
          link_to(text, "##{anchor_str}", class: "fr-link")
        end
      end
    end

    def default_skip_links
      result = [
        skip_link(content_skip_link_text, "content"),
        skip_link("Menu", "header"),
        skip_link("Pied de page", "footer")
      ].join

      result.respond_to?(:html_safe) ? result.html_safe : result
    end

    def skip_links_content
      return content_for(:skip_links) if content_for?(:skip_links)

      validate_skip_links_in_test! if defined?(Rails) && Rails.env.test?
      default_skip_links
    end

    def content_skip_link_text
      return content_for(:content_skip_link_text) if content_for?(:content_skip_link_text)

      "Aller au contenu"
    end

    private

    def validate_skip_links_in_test!
      return true unless defined?(Rails) && Rails.env.test?
      return true unless respond_to?(:controller)
      return true if DsfrAccessibleSkipLinks.configuration.disable_validation

      has_custom_skip_links = content_for?(:skip_links)

      SkipLinksImplementedChecker.new(
        controller_name: controller.controller_name,
        action_name: controller.action_name,
        has_skip_links: has_custom_skip_links
      ).perform!
    end
  end
end

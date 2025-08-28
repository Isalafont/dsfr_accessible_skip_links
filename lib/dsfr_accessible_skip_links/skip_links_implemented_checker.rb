# frozen_string_literal: true

module DsfrAccessibleSkipLinks
  class SkipLinksImplementedChecker
    attr_reader :controller_name, :action_name, :has_skip_links

    def initialize(controller_name:, action_name:, has_skip_links: false)
      @controller_name = controller_name
      @action_name = action_name
      @has_skip_links = has_skip_links
    end

    def perform!
      return true if has_skip_links
      return true if whitelisted?

      current_route = "#{controller_name}##{action_name}"
      raise SkipLinksNotDefinedError,
            "No skip links defined for this page (#{current_route}). " \
            "Use content_for(:skip_links) to define skip links or " \
            "define them in a view-specific helper."
    end

    private

    def whitelisted?
      DsfrAccessibleSkipLinks.configuration.whitelisted_routes.include?("#{controller_name}##{action_name}")
    end

    class SkipLinksNotDefinedError < StandardError; end
  end
end

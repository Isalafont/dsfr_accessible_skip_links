# frozen_string_literal: true

require_relative "dsfr_accessible_skip_links/version"
require_relative "dsfr_accessible_skip_links/configuration"
require_relative "dsfr_accessible_skip_links/engine" if defined?(Rails)
require_relative "dsfr_accessible_skip_links/skip_links"
require_relative "dsfr_accessible_skip_links/skip_links_implemented_checker"

module DsfrAccessibleSkipLinks
  class Error < StandardError; end
end

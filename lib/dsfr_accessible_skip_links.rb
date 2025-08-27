# frozen_string_literal: true

require_relative "dsfr_accessible_skip_links/version"
require_relative "dsfr_accessible_skip_links/engine" if defined?(Rails)
require_relative "dsfr_accessible_skip_links/skip_links"

module DsfrAccessibleSkipLinks
  class Error < StandardError; end
end

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2025-08-28
### Added
- **SkipLinksImplementedChecker**: New validation service to ensure skip links are properly implemented across applications
- **Configuration system**: Allow users to configure whitelisted routes that are exempt from validation
- **Disable validation option**: New `disable_validation` configuration for projects with existing validation systems
- Comprehensive test coverage for validation functionality

### Changed
- Improved README documentation with clearer installation and usage instructions
- Enhanced generator functionality and reliability
- Updated README with complete documentation for validation features and configuration options

## [0.1.3] - 2025-08-27
### Fixed
- Generator now uses `copy_file` instead of `template` to avoid evaluating ERB in the partial during generation. This prevents `NameError` for `skip_links_content`.
- Ensure DsfrAccessibleSkipLinks::SkipLinks is automatically included using `ActiveSupport.on_load` hooks:
- Included into `ActionController::Base` (controller-side) and exposed as view helpers
- Included into `ActionView` (view-side) so helpers are available in templates without manual setup

## [0.1.2] - 2025-08-27
### Added
- Rails generator `dsfr_accessible_skip_links:install` to copy the skip links partial and inject the render call into the application layout.
- README updated with installation instructions using the generator.

## [0.1.1] - 2025-08-27
### Fixed
- Minor bug fixes and improvements

## [0.1.0] - 2025-08-27

### Added
- Initial release
- Skip links helper methods for Rails applications
- DSFR-compliant CSS classes and HTML structure
- Configuration system for customizing default behavior
- Accessibility features following WCAG 2.2 guidelines

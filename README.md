# DsfrAccessibleSkipLinks

A Ruby gem that helps projects implement accessible skip links according to the French government design system (DSFR - Système de design de l'État français). This gem provides helpers and utilities for creating navigation skip links that improve web accessibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dsfr_accessible_skip_links'
```

Then install the gem:

    $ bundle install

Run the installer to set up the skip links in your Rails app:

    $ bin/rails g dsfr_accessible_skip_links:install

This will:
- Copy the skip links partial to `app/views/shared/_skip_links.html.erb`
- Show you instructions on how to add it to your layout

**Next step:** Add the render call to your layout file (typically `app/views/layouts/application.html.erb`):

```erb
<body>
  <%= render 'shared/skip_links' %>
  <!-- rest of your content -->
</body>
```

**Quick setup option:** Use `--inject-layout` flag to automatically add the render call:

    $ bin/rails g dsfr_accessible_skip_links:install --inject-layout

You can also install the gem itself directly as:

    $ gem install dsfr_accessible_skip_links

## Usage

### Required Elements

Make sure your layout contains these elements with the correct IDs:

```erb
<header id="header">
  <!-- your navigation -->
</header>

<main id="content">
  <%= yield %>
</main>

<footer id="footer">
  <!-- your footer -->
</footer>
```

The gem automatically integrates with Rails through a Rails Engine. Helper methods are automatically available in all controllers and views.

### Default Skip Links

By default, the gem provides three skip links:
- **"Aller au contenu"** → `#content`
- **"Menu"** → `#header`  
- **"Pied de page"** → `#footer`

### Custom Skip Links

You can customize skip links on a per-page basis using Rails' `content_for`:

```erb
<% content_for :skip_links do %>
  <%= skip_link('Aller au contenu principal', 'main-section') %>
  <%= skip_link('Aller à la navigation spéciale', 'special-nav') %>
  <%= skip_link('Aller aux résultats', 'results') %>
<% end %>
```

### Custom Content Link Text

You can customize the main content link text:

```erb
<% content_for :content_skip_link_text, 'Go to main content' %>
```

### Tab-Prefixed Links

For links that need JavaScript interaction, use the `tab-` prefix:

```erb
<%= skip_link('Tab Navigation', 'tab-special-section') %>
```

This will add a `data-anchor` attribute for JavaScript handling.

### Helper Methods

The gem provides these helper methods (automatically available in controllers and views):

- `skip_link(text, anchor)` - Creates a single skip link
- `default_skip_links` - Returns the default set of skip links
- `skip_links_content` - Returns either custom or default skip links
- `content_skip_link_text` - Returns the content link text

### CSS Classes

The gem uses official DSFR CSS classes:
- `.fr-skiplinks` - Main container
- `.fr-container` - DSFR container wrapper
- `.fr-skiplinks__list` - List container
- `.fr-link` - Individual link styling

### HTML Structure

The generated HTML follows this structure:

```html
<div class="fr-skiplinks">
  <nav class="fr-container" role="navigation" aria-label="Accès rapide">
    <ul class="fr-skiplinks__list">
      <li><a class="fr-link" href="#content">Aller au contenu</a></li>
      <li><a class="fr-link" href="#header">Menu</a></li>
      <li><a class="fr-link" href="#footer">Pied de page</a></li>
    </ul>
  </nav>
</div>
```

## Skip Links Validation

The gem includes a validation service to ensure skip links are properly implemented across your application during testing.

### SkipLinksImplementedChecker

The `SkipLinksImplementedChecker` service automatically validates that pages either:
- Have custom skip links defined via `content_for(:skip_links)`
- Are included in your whitelisted routes configuration

This validation runs automatically in test environments when skip links are rendered.

### Configuration

Configure routes that should be exempt from skip links validation:

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.whitelisted_routes = [
    'pages#home',
    'pages#about',
    'admin/dashboard#index',
    'users#show',
    'posts#index'
  ]
end
```

### Disabling Validation

If your project already has its own skip links validation system, you can disable the gem's built-in validation:

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.disable_validation = true
end
```

When `disable_validation` is set to `true`:
- The `SkipLinksImplementedChecker` will not run automatically in tests
- You can still use the gem's helper methods for generating skip links
- No validation errors will be raised, giving you full control over accessibility checks

### Manual Usage

You can also use the checker manually in your tests or application:

```ruby
# In a controller or test
checker = DsfrAccessibleSkipLinks::SkipLinksImplementedChecker.new(
  controller_name: 'posts',
  action_name: 'show',
  has_skip_links: content_for?(:skip_links)
)

begin
  checker.perform!
  # Skip links are properly configured
rescue DsfrAccessibleSkipLinks::SkipLinksImplementedChecker::SkipLinksNotDefinedError => e
  # Handle missing skip links
  puts e.message
end
```

### Integration in Rails Tests

The validation automatically runs during testing. If a page lacks skip links and isn't whitelisted, you'll see:

```
DsfrAccessibleSkipLinks::SkipLinksImplementedChecker::SkipLinksNotDefinedError: 
No skip links defined for this page (posts#show). Use content_for(:skip_links) 
to define skip links or define them in a view-specific helper.
```

To fix this, either:
1. Add the route to your whitelist configuration
2. Define custom skip links in your view:

```erb
<% content_for :skip_links do %>
  <%= skip_link('Aller au contenu', 'main-content') %>
  <%= skip_link('Aller aux commentaires', 'comments') %>
<% end %>
```

## Accessibility Features

This gem implements skip links following [WCAG 2.2 guidelines](https://www.w3.org/WAI/WCAG22/quickref/) and [DSFR (Système de Design de l'État français)](https://www.systeme-de-design.gouv.fr/) specifications:

### Standards Compliance
- **WCAG 2.2 Level AA**: Complies with international web accessibility standards
- **DSFR Guidelines**: Follows French government design system accessibility requirements
- **RGAA 4.1**: Compatible with French web accessibility reference guidelines (Référentiel Général d'Amélioration de l'Accessibilité)

### Technical Features
- **Semantic HTML**: Proper structure with `<nav>` element and `role="navigation"`
- **Screen Reader Support**: Descriptive `aria-label="Accès rapide"` for assistive technologies
- **Keyboard Navigation**: Full keyboard accessibility with proper focus management
- **Skip to Content**: Direct navigation to main content areas (#content, #header, #footer)
- **Visual Design**: Compatible with official DSFR CSS classes for consistent styling

### Quality Assurance
- **Automated Validation**: Built-in checker ensures skip links are not forgotten on any page
- **Test Environment Integration**: Validates skip links presence during test runs
- **Configurable Validation**: Whitelist specific routes that don't require skip links
- **Development Feedback**: Clear error messages guide developers to implement missing skip links

### DSFR Integration
This gem implements the official [DSFR skip links component](https://www.systeme-de-design.gouv.fr/elements-d-interface/composants/liens-d-evitement) following:
- Official CSS classes (`.fr-skiplinks`, `.fr-container`, `.fr-skiplinks__list`, `.fr-link`)
- Recommended HTML structure and ARIA attributes
- French language defaults for government websites
- Responsive design compatibility

### Accessibility Benefits
- **Faster Navigation**: Screen reader and keyboard users can quickly skip to main content
- **Reduced Cognitive Load**: Clear navigation structure improves user experience
- **Legal Compliance**: Helps meet French accessibility requirements for public sector websites
- **Universal Design**: Benefits all users, especially those with motor or visual impairments

For more information about French web accessibility requirements, visit:
- [DSFR Official Documentation](https://www.systeme-de-design.gouv.fr/)
- [RGAA Guidelines](https://www.numerique.gouv.fr/publications/rgaa-accessibilite/)
- [WCAG 2.2 Guidelines](https://www.w3.org/WAI/WCAG22/quickref/)

## How to test this gem

There are two main ways to test this gem:

1) Run the gem's test suite locally (fast, no Rails app needed)
- Install dependencies:
  ```bash
  bundle install
  ```
- Run RSpec:
  ```bash
  bundle exec rake spec
  ```
- Run RuboCop:
  ```bash
  bundle exec rake rubocop
  ```
- Run both (default task):
  ```bash
  bundle exec rake
  ```

2) Try it inside a real Rails app (to test the generator and integration)
- Create a new Rails app (or use an existing one):
  ```bash
  rails new demo_app --skip-javascript --skip-hotwire --skip-action-mailbox --skip-action-text --skip-active-storage --skip-active-job --skip-system-test
  cd demo_app
  ```
- Point the app to your local copy of this gem. In demo_app/Gemfile add:
  ```ruby
  gem 'dsfr_accessible_skip_links', path: '../path/to/your/dsfr_accessible_skip_links'
  ```
  Then run:
  ```bash
  bundle install
  ```
- Run the installer:
  ```bash
  bin/rails g dsfr_accessible_skip_links:install
  ```
- Verify the partial exists at: `app/views/shared/_skip_links.html.erb`
- Add the render call to your layout and ensure required HTML elements exist (see Usage section above)
- Start the server and check the skip links at the top of the page:
  ```bash
  bin/rails s
  ```
  Visit http://localhost:3000 and look for the skip links markup
  ("Aller au contenu", "Menu", "Pied de page").

**Notes:**
- The generator is idempotent: it won't insert the render line twice if it already exists.

### Setting up Skip Links Validation

After installing the gem, create an initializer to configure whitelisted routes:

```bash
# Create the initializer file
touch config/initializers/dsfr_accessible_skip_links.rb
```

Add your configuration:

```ruby
# config/initializers/dsfr_accessible_skip_links.rb
DsfrAccessibleSkipLinks.configure do |config|
  config.whitelisted_routes = [
    # Landing pages that use default skip links
    'pages#home',
    'pages#about',
    'pages#contact',
    
    # Admin pages with standard layout
    'admin/dashboard#index',
    'admin/users#index',
    
    # API endpoints or pages without standard layout
    'api/health#check',
    'errors#not_found'
  ]
end
```

This configuration ensures that:
- Listed routes won't trigger validation errors in tests
- Pages not in the whitelist must define custom skip links
- You maintain accessibility compliance across your application

## Development

After checking out the repo, run `bundle install` to install dependencies. 

Run the test suite:
```bash
bundle exec rake spec
```

Run RuboCop for code quality checks:
```bash
bundle exec rake rubocop
```

Run both tests and RuboCop:
```bash
bundle exec rake
```

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Isalafont/dsfr_accessible_skip_links.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

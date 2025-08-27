# DsfrAccessibleSkipLinks

A Ruby gem that helps projects implement accessible skip links according to the French government design system (DSFR - Système de design de l'État français). This gem provides helpers and utilities for creating navigation skip links that improve web accessibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dsfr_accessible_skip_links'
```

Then install the gem:

    $ bundle install

Run the installer to set up the skip links in your Rails app (copies the partial and injects the render in your layout):

    $ bin/rails g dsfr_accessible_skip_links:install

You can also install the gem itself directly as:

    $ gem install dsfr_accessible_skip_links

## Usage

### Rails Integration

The gem automatically integrates with Rails through a Rails Engine. The `SkipLinks` module is automatically included in `ApplicationController`.

In your layout file (e.g., `app/views/layouts/application.html.erb`), add the skip links at the top:

```erb
<!DOCTYPE html>
<html>
  <head>
    <!-- head content -->
  </head>
  <body>
    <%= render partial: 'shared/skip_links' %>
    
    <!-- rest of your layout -->
    <header id="header">
      <!-- your navigation -->
    </header>
    
    <main id="content">
      <%= yield %>
    </main>
    
    <footer id="footer">
      <!-- your footer -->
    </footer>
  </body>
</html>
```

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

## Accessibility Features

This gem implements skip links following WCAG 2.2 guidelines and DSFR specifications:

- Proper semantic HTML structure with `nav` element and `role="navigation"`
- Descriptive `aria-label` for screen readers
- Keyboard navigation support
- Focus management
- Compatible with DSFR CSS for visual styling

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
- Run the installer (copies the partial and injects a render line into your layout):
  ```bash
  bin/rails g dsfr_accessible_skip_links:install
  ```
- Verify changes:
  - The partial should exist at: app/views/shared/_skip_links.html.erb
  - Your app layout (app/views/layouts/application.html.erb) should include:
    ```erb
    <%= render partial: 'shared/skip_links' %>
    ```
  - Ensure your layout has the anchor targets used by default links:
    ```erb
    <header id="header"></header>
    <main id="content"><%= yield %></main>
    <footer id="footer"></footer>
    ```
- Start the server and check the skip links at the top of the page:
  ```bash
  bin/rails s
  ```
  Visit http://localhost:3000 and look for the skip links markup
  ("Aller au contenu", "Menu", "Pied de page").

Notes
- The generator is idempotent: it won’t insert the render line twice if it already exists.
- You can customize the skip links in any view using `content_for :skip_links` as described below in Usage.

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

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Isalafont/dsfr_accessible_skip_links.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

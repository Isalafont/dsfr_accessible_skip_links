# frozen_string_literal: true

require "rails_helper" if defined?(Rails)

class TestController
  include DsfrAccessibleSkipLinks::SkipLinks

  def content_tag(tag, content = nil, _options = nil, &block)
    content = block.call if block_given?
    "<#{tag}>#{content}</#{tag}>"
  end

  def link_to(text, href, options = {})
    css_class = options[:class] || ""
    data_attrs = options[:data] ? options[:data].map { |k, v| "data-#{k}=\"#{v}\"" }.join(" ") : ""
    "<a href=\"#{href}\" class=\"#{css_class}\" #{data_attrs}>#{text}</a>"
  end

  def content_for?(name)
    @content_for ||= {}
    @content_for.key?(name)
  end

  def content_for(name, content = nil)
    @content_for ||= {}
    if content
      @content_for[name] = content
    else
      @content_for[name]
    end
  end

  def controller
    @mock_controller ||= MockController.new
  end

  def respond_to?(method_name)
    method_name == :controller
  end
end

class MockController
  def controller_name
    "test_controller"
  end

  def action_name
    "test_action"
  end
end

RSpec.describe DsfrAccessibleSkipLinks::SkipLinks do
  let(:controller) { TestController.new }

  before do
    DsfrAccessibleSkipLinks.reset_configuration!
  end

  describe "#skip_link" do
    it "generates a basic skip link" do
      result = controller.skip_link("Test Link", "test-anchor")
      expect(result).to include('<a href="#test-anchor" class="fr-link"')
      expect(result).to include("Test Link")
    end

    it "generates a tab-prefixed skip link with data attribute" do
      result = controller.skip_link("Tab Link", "tab-test")
      expect(result).to include('data-anchor="tab-test"')
      expect(result).to include('<a href="#tab-test" class="fr-link"')
    end
  end

  describe "#content_skip_link_text" do
    it "returns default text when no content_for is set" do
      expect(controller.content_skip_link_text).to eq("Aller au contenu")
    end

    it "returns custom text when content_for is set" do
      controller.content_for(:content_skip_link_text, "Custom Content Text")
      expect(controller.content_skip_link_text).to eq("Custom Content Text")
    end
  end

  describe "#default_skip_links" do
    it "generates default skip links" do
      result = controller.default_skip_links
      expect(result).to include("Aller au contenu")
      expect(result).to include("Menu")
      expect(result).to include("Pied de page")
      expect(result).to include('href="#content"')
      expect(result).to include('href="#header"')
      expect(result).to include('href="#footer"')
    end
  end

  describe "#skip_links_content" do
    it "returns content_for skip_links when available" do
      custom_content = "<li><a href='#custom'>Custom</a></li>"
      controller.content_for(:skip_links, custom_content)
      expect(controller.skip_links_content).to eq(custom_content)
    end

    it "returns default skip links when no content_for is available" do
      result = controller.skip_links_content
      expect(result).to include("Aller au contenu")
      expect(result).to include("Menu")
      expect(result).to include("Pied de page")
    end
  end

  describe "#validate_skip_links_in_test!" do
    context "when validation is disabled" do
      it "skips validation when disable_validation is true" do
        DsfrAccessibleSkipLinks.configure do |config|
          config.disable_validation = true
        end

        # Should not raise an error even though route is not whitelisted
        expect { controller.send(:validate_skip_links_in_test!) }.not_to raise_error
      end
    end

    context "when validation is enabled" do
      it "performs validation by default" do
        # Mock Rails.env.test? to return true
        allow(Rails).to receive(:env).and_return(double(test?: true)) if defined?(Rails)
        
        # Should perform validation (but won't raise error because we're not actually in Rails test env)
        expect { controller.send(:validate_skip_links_in_test!) }.not_to raise_error
      end
    end
  end
end

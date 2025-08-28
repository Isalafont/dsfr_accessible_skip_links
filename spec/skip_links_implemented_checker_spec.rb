# frozen_string_literal: true

require "spec_helper"

RSpec.describe DsfrAccessibleSkipLinks::SkipLinksImplementedChecker do
  before do
    DsfrAccessibleSkipLinks.reset_configuration!
  end
  describe "#perform!" do
    context "when has_skip_links is true" do
      it "returns true" do
        checker = described_class.new(
          controller_name: "test",
          action_name: "show",
          has_skip_links: true
        )
        expect(checker.perform!).to be true
      end
    end

    context "when route is whitelisted" do
      it "returns true for whitelisted routes" do
        DsfrAccessibleSkipLinks.configure do |config|
          config.whitelisted_routes = ["pages#home"]
        end

        checker = described_class.new(
          controller_name: "pages",
          action_name: "home",
          has_skip_links: false
        )
        expect(checker.perform!).to be true
      end
    end

    context "when route is not whitelisted and has no skip links" do
      it "raises SkipLinksNotDefinedError" do
        checker = described_class.new(
          controller_name: "test",
          action_name: "show",
          has_skip_links: false
        )
        expect { checker.perform! }.to raise_error(
          DsfrAccessibleSkipLinks::SkipLinksImplementedChecker::SkipLinksNotDefinedError,
          "No skip links defined for this page (test#show). /
					 Use content_for(:skip_links) to define skip links or define them in a view-specific helper."
        )
      end
    end

    context "with nested controller routes" do
      it "handles namespaced controllers correctly" do
        DsfrAccessibleSkipLinks.configure do |config|
          config.whitelisted_routes = ["instruction/authorization_requests#index"]
        end

        checker = described_class.new(
          controller_name: "instruction/authorization_requests",
          action_name: "index",
          has_skip_links: false
        )
        expect(checker.perform!).to be true
      end
    end
  end

  describe "#whitelisted?" do
    it "returns true for whitelisted routes" do
      DsfrAccessibleSkipLinks.configure do |config|
        config.whitelisted_routes = ["pages#accessibilite"]
      end

      checker = described_class.new(
        controller_name: "pages",
        action_name: "accessibilite",
        has_skip_links: false
      )
      expect(checker.send(:whitelisted?)).to be true
    end

    it "returns false for non-whitelisted routes" do
      checker = described_class.new(
        controller_name: "custom",
        action_name: "action",
        has_skip_links: false
      )
      expect(checker.send(:whitelisted?)).to be false
    end
  end

  describe "configuration" do
    it "allows users to configure whitelisted routes" do
      DsfrAccessibleSkipLinks.configure do |config|
        config.whitelisted_routes = ["custom#action", "another#route"]
      end

      checker = described_class.new(
        controller_name: "custom",
        action_name: "action",
        has_skip_links: false
      )
      expect(checker.perform!).to be true
    end

    it "uses empty array by default" do
      expect(DsfrAccessibleSkipLinks.configuration.whitelisted_routes).to eq([])
    end

    it "can reset configuration" do
      DsfrAccessibleSkipLinks.configure do |config|
        config.whitelisted_routes = ["test#route"]
      end

      DsfrAccessibleSkipLinks.reset_configuration!
      expect(DsfrAccessibleSkipLinks.configuration.whitelisted_routes).to eq([])
    end
  end

  describe "initialization" do
    it "sets attributes correctly" do
      checker = described_class.new(
        controller_name: "test_controller",
        action_name: "test_action",
        has_skip_links: true
      )

      expect(checker.controller_name).to eq("test_controller")
      expect(checker.action_name).to eq("test_action")
      expect(checker.has_skip_links).to be true
    end

    it "defaults has_skip_links to false" do
      checker = described_class.new(
        controller_name: "test",
        action_name: "show"
      )
      expect(checker.has_skip_links).to be false
    end
  end
end

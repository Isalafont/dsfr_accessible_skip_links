# frozen_string_literal: true

require "spec_helper"

RSpec.describe DsfrAccessibleSkipLinks::Configuration do
  before do
    DsfrAccessibleSkipLinks.reset_configuration!
  end

  describe "#whitelisted_routes" do
    it "defaults to empty array" do
      config = described_class.new
      expect(config.whitelisted_routes).to eq([])
    end

    it "can be set to custom routes" do
      config = described_class.new
      routes = ["pages#home", "users#show"]
      config.whitelisted_routes = routes
      expect(config.whitelisted_routes).to eq(routes)
    end
  end

  describe "#disable_validation" do
    it "defaults to false" do
      config = described_class.new
      expect(config.disable_validation).to be false
    end

    it "can be set to true" do
      config = described_class.new
      config.disable_validation = true
      expect(config.disable_validation).to be true
    end
  end

  describe "module configuration methods" do
    it "provides a configuration instance" do
      expect(DsfrAccessibleSkipLinks.configuration).to be_a(described_class)
    end

    it "yields configuration for setup" do
      DsfrAccessibleSkipLinks.configure do |config|
        expect(config).to be_a(described_class)
        config.whitelisted_routes = ["test#route"]
      end

      expect(DsfrAccessibleSkipLinks.configuration.whitelisted_routes).to eq(["test#route"])
    end

    it "maintains the same configuration instance" do
      config1 = DsfrAccessibleSkipLinks.configuration
      config2 = DsfrAccessibleSkipLinks.configuration
      expect(config1).to be(config2)
    end

    it "can reset configuration" do
      DsfrAccessibleSkipLinks.configure do |config|
        config.whitelisted_routes = ["some#route"]
        config.disable_validation = true
      end

      DsfrAccessibleSkipLinks.reset_configuration!
      expect(DsfrAccessibleSkipLinks.configuration.whitelisted_routes).to eq([])
      expect(DsfrAccessibleSkipLinks.configuration.disable_validation).to be false
    end

    it "allows disabling validation through configuration" do
      DsfrAccessibleSkipLinks.configure do |config|
        config.disable_validation = true
      end

      expect(DsfrAccessibleSkipLinks.configuration.disable_validation).to be true
    end
  end
end
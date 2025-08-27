# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
task :rubocop do
  sh "bundle exec rubocop"
end

task default: %i[rubocop spec]

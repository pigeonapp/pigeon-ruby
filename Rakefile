require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

default_tasks = []

RSpec::Core::RakeTask.new(:spec)

default_tasks << :spec

# Rubocop doesn't support < 2.3 - https://github.com/rubocop-hq/rubocop#compatibility
if RUBY_VERSION >= '2.3'
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
  end

  default_tasks << :rubocop
end

default_tasks << :rubocop

task default: default_tasks

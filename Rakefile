require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'parallel_tests/tasks'
require 'shellwords'
require_relative 'support/config'
require 'rspec/core/rake_task'
Dir.glob('lib/tasks/*.rake').each { |r| load r }
require 'rake/clean'
require 'fileutils'

CLEAN.include 'output/**'
FileUtils.mkdir_p 'output/json'

def default_feature_files
  return 'features/common' if Dir.exist?('features/common')
end

def default_opts
  default_profile = ENV['PROFILE'] || 'ci'
  "-p #{default_profile} #{default_feature_files}"
end

def default_threads
  ENV['THREADS'] || '4'
end

def default_tags
  ENV['TAGS'] =='' ? '' : "-t @#{ENV['TAGS']}"
end

def default_profile
  ENV['PROFILE'] || 'ci'
end

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = default_opts
end

namespace :cucumber do
  rule /^cucumber:/ do |task|
    tag = task.name.split(':').last
    puts "Running cucumber tag: #{tag}"
    Cucumber::Rake::Task.new(task.name) do |t|
      t.cucumber_opts = " --tags @#{tag} #{default_opts}"
    end
    Rake::Task[task.name].invoke
    at_exit {
      generate_report_from_json_result
    }
  end

  Rake::Task[:cucumber].enhance do
    generate_report_from_json_result
  end
end

task :parallel_features, :tag, 'Run Cucumber tests in parallel' do |t, args|
  default_profile = 'ci'
  tags = "--tags @#{args[:tag]}" if args[:tag]
  puts "Running parallel tests with tag: #{tags}"
  no_of_parallel_tests = (ENV['PARALLEL_TESTS'] || 4).to_i
  Rake::Task['parallel:features'].invoke(no_of_parallel_tests, "\\/", "-p #{default_profile} #{tags}")
end

def generate_report_from_json_result(account = nil)
  if (Dir.glob(File.join("output/json/*.json")).select {|file| File.file?(file)}.count > 0)
    if account.nil?
      system("report_builder -s 'output/json' -o output/report_from_json_result -t overview,features,scenarios,errors")
    else
      system("report_builder -s 'output/json' -o output/report_from_json_result_#{account} -t overview,features,scenarios,errors")
    end
  end
end

begin
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = Dir.glob('spec/**/*_spec.rb')
    t.rspec_opts = '--format documentation --format RspecJunitFormatter --out output/junit/rspec.xml'
  end
  task default: :spec
rescue LoadError
  puts 'Error running rake task'
end
require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ['modules/**/**/*.pp','pkg/**/**/*.pp','spec/fixtures/modules/**/**/*.pp']
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
  config.disable_checks = [ 'autoloader_layout', 'class_inherits_from_params_class']
end

task :metadata do
  sh "metadata-json-lint metadata.json"
end

task :default => [ :syntax, :lint, :spec, :metadata ]

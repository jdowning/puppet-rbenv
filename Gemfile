source ENV['GEM_SOURCE'] || 'https://rubygems.org'
ruby file: ".ruby-version"

def location_for(place_or_version, fake_version = nil)
  git_url_regex = %r{\A(?<url>(https?|git)[:@][^#]*)(#(?<branch>.*))?}
  file_url_regex = %r{\Afile:\/\/(?<path>.*)}

  if place_or_version && (git_url = place_or_version.match(git_url_regex))
    [fake_version, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_version && (file_url = place_or_version.match(file_url_regex))
    ['>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

group :development do
  gem "dependency_checker", '~> 1.0',              require: false
  gem "facterdb", '~> 4.5',                        require: false
  gem "json",                                      require: false
  gem "metadata-json-lint", '~> 5.1',              require: false
  gem "parallel_tests", '~> 5.9',                  require: false
  gem "pry", '~> 0.10',                            require: false
  gem "puppet-debugger", '~> 1.0',                 require: false
  gem "puppetlabs_spec_helper", '~> 9.0',          require: false
  gem "rb-readline", '= 0.5.5',                    require: false, platforms: [:mswin, :mingw, :x64_mingw]
  gem "rspec-puppet-facts", '~> 6.3',              require: false
  gem "rubocop",                                   require: false
  gem "rubocop-performance",                       require: false
  gem "rubocop-rspec",                             require: false
  gem "simplecov-console", '~> 0.9',               require: false
  gem "voxpupuli-puppet-lint-plugins", '~> 7.0',   require: false
end

gem "syslog", require: false, platforms: [:ruby]

group :system_tests do
  gem "puppet_litmus", require: false, platforms: [:ruby, :x64_mingw]
  gem "serverspec", '~> 2.43',    require: false
end

puppet_version = ENV['PUPPET_GEM_VERSION']
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']

gems = {}

gems['puppet'] = location_for(puppet_version)

# If facter or hiera versions have been specified via the environment
# variables

gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

# vim: syntax=ruby

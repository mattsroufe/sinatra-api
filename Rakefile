task :default => :test

desc "Run all tests"
task(:test) do
  Dir['./spec/**/*_spec.rb'].each { |f| load f }
end

require './app'
require 'sinatra/activerecord/rake'

__END__

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

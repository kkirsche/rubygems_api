require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems_api'
require 'hurley/test'
require 'minitest/autorun'

module TestRubygemsAPI
end

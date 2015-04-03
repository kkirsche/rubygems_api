require 'minitest_helper'
module TestRubygemsAPI
  # Test general gem requirements
  class TestRubygems
    describe 'Rubygems API Client', 'API connection tasks' do
      it 'should return a hash of total rubygems downloads when being sent' \
         ' JSON or YAML' do
        client = Rubygems::API::Client.new

        client.client.connection = Hurley::Test.new do |test|
          test.get '/api/v1/downloads.json' do
            [200, { 'Content-Type' => 'application/json' }, %({"id": 1})]
          end

          test.get '/api/v1/downloads.yaml' do
            [200, { 'Content-Type' => 'application/yaml' }, %(---
            :total: 4817644982)]
          end
        end

        response = client.rubygems_total_downloads('json').body
        response['id'].must_equal 1

        response = client.rubygems_total_downloads('yaml').body
        response[:total].must_equal 4_817_644_982
      end

      it 'should return a hash body when being sent JSON' do
        client = Rubygems::API::Client.new

        client.client.connection = Hurley::Test.new do |test|
          test.get '/api/v1/gems/rubygems_api.json' do
            [200, { 'Content-Type' => 'application/json' }, %({"id": 1})]
          end
        end

        response = client.gem_info('rubygems_api', 'json').body
        response['id'].must_equal 1
      end

      it 'should return a hash body when being sent YAML' do
        client = Rubygems::API::Client.new

        client.client.connection = Hurley::Test.new do |test|
          test.get '/api/v1/gems/rubygems_api.yaml' do
            [200, { 'Content-Type' => 'application/yaml' }, %(---
            :total: 4817644982)]
          end
        end

        response = client.gem_info('rubygems_api', 'yaml').body
        response[:total].must_equal 4_817_644_982
      end
    end
  end
end

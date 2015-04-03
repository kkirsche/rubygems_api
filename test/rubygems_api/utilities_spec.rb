require 'minitest_helper'
module TestRubygemsAPI
  # Test general gem requirements
  class TestRubygems
    describe 'Rubygems API Utilities', 'General gem tests' do
      it 'should return true if format is JSON or YAML' do
        client = Rubygems::API::Client.new

        response = client.validate_format('json')
        response.must_equal true

        response = client.validate_format('yaml')
        response.must_equal true
      end

      it 'should raise an error if the format is unexpected' do
        client = Rubygems::API::Client.new
        assert_raises RuntimeError do
          client.validate_format('unsupported format')
        end
      end

      it 'should return a hash body when being sent JSON' do
        client = Rubygems::API::Client.new

        client.client.connection = Hurley::Test.new do |test|
          test.get '/api/v1/downloads.json' do
            [200, { 'Content-Type' => 'application/json' }, %({"id": 1})]
          end
        end

        response = client.rubygems_total_downloads.body
        response['id'].must_equal 1
      end

      it 'should return a hash body when being sent YAML' do
        client = Rubygems::API::Client.new

        client.client.connection = Hurley::Test.new do |test|
          test.get '/api/v1/downloads.yaml' do
            [200, { 'Content-Type' => 'application/yaml' }, %(---
            :total: 4817644982)]
          end
        end

        response = client.rubygems_total_downloads('yaml').body
        response[:total].must_equal 4_817_644_982
      end
    end
  end
end

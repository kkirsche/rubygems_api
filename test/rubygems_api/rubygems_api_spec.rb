require 'minitest_helper'
module TestRubygemsAPI
  # Test general gem requirements
  class TestRubygems
    describe 'Rubygems API', 'General gem tests' do
      it 'should have a version number' do
        Rubygems::API::VERSION.wont_be_nil
      end
    end
  end
end

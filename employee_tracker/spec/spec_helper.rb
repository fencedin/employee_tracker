require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'employee'
require 'division'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Employee.all.each { |employee| employee.destroy }
    Division.all.each { |division| division.destroy }
  end
end

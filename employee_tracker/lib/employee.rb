class Employee < ActiveRecord::Base
  has_many(:projects)
end

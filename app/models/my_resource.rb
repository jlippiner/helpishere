class MyResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :profile
end

class Resource < ActiveRecord::Base
  belongs_to :disease
  belongs_to :listing
  belongs_to :user
end

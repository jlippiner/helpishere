class Experience < ActiveRecord::Base
  belongs_to :resource
  belongs_to :user

  validates_presence_of :comment
  validates_uniqueness_of :title, :scope => [:comment]

end

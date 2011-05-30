class Book < ActiveRecord::Base
  has_many :buyings
  has_many :users, :through => :buyings
end

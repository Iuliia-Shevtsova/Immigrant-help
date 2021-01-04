class Category < ApplicationRecord
  belongs_to :user

  validates_presence_of :category_name
end

class Book < ActiveRecord::Base
  belongs_to :order
  
  validates :title,  presence: true, length: { maximum: 50 }
  validates :author, presence: true, length: { maximum: 50 }
  validates :year,   presence: true, length: { maximum: 4  }
end

class Product < ActiveRecord::Base
  has_many :reviews

  def review_average
    self.reviews.average(:rate).round
  end
end

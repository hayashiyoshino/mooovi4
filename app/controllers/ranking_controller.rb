class RankingController < ApplicationController
  layout 'review_site'

  before_action :ranking

  def ranking
    product_ids = Review.group(:product_id).order('count_product_id DESC').limit(5).count(:product_id).keys
    # Review.group(:product_id)で、product_idごとにReviewのレコードがまとめられる。
    # order('count_product_id DESC')で、product_idでまとめたレコードをレコード数でソート。
    # count(:product_id)で、カラム名(product_id)とレコードの数のハッシュで返す。
    # ActiveRecord::Relationクラスは複数のレコードの配列のような形のクラス。
    # orderはActiveRecord::Rerationクラスのメソッドなのでハッシュには使えない。
    # limitはActiveRecord::Rerationクラスのメソッドなのでハッシュには使えない。
    @ranking = product_ids.map { |id| Product.find(id) }
  end
end

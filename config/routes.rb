TechReviewSite::Application.routes.draw do

  devise_for :users
  resources :products, only: :show do
    resources :reviews, only: [:new, :create]
    # get 'products/:products_id/reviews/new' => 'reviews#new'
    # post 'products/:products_id/reviews' => 'reviews#create'

    collection do
      get 'search'
    end
  end
  root 'products#index'

end

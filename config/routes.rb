Rails.application.routes.draw do

  # Home endpoint
  root 'home#index'
  get 'home/index' => 'home#index'

  # Movies CRUD endpoints
  get 'movies' => 'movie#index'
  get 'movies/new' => 'movie#new'
  get 'movies/:movie_id' => 'movie#show'
  post '/movies' => 'movie#create'
  get 'movies/:movie_id/edit' => 'movie#edit'
  put 'movies/:movie_id' => 'movie#update'
  delete 'movies/:movie_id' => 'movie#destroy'

  # Tvs CRUD endpoints
  get 'tvs' => 'tv#index'
  get 'tvs/new' => 'tv#new'
  get 'tvs/:tv_id' => 'tv#show'
  post '/tvs' => 'tv#create'
  get 'tvs/:tv_id/edit' => 'tv#edit'
  put 'tvs/:tv_id' => 'tv#update'
  delete 'tvs/:tv_id' => 'tv#destroy'

  # People CRUD endpoints
  get 'people' => 'person#index'
  get 'people/new' => 'person#new'
  get 'people/:person_id' => 'person#show'
  post '/people' => 'person#create'
  get 'people/:person_id/edit' => 'person#edit'
  put 'people/:person_id' => 'person#update'
  delete 'people/:person_id' => 'person#destroy'

  # MovieCredits CR endpoints
  get 'movie_credits' => 'movie_credit#index'
  post '/movie_credits' => 'movie_credit#create'

  # TvCredits CR endpoints
  get 'tv_credits' => 'tv_credit#index'
  post '/tv_credits' => 'tv_credit#create'

end

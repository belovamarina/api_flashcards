ApiFlashcards::Engine.routes.draw do
  root to: 'main#index'

  namespace :v1 do
    resources :cards, only: %i[index create]
    get 'trainer' => 'trainer#index'
    put 'review_card' => 'trainer#review_card'
  end
end

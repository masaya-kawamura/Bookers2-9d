Rails.application.routes.draw do
  root 'homes#top'
  get 'home/about' => 'homes#about'
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users,only: [:show,:index,:edit,:update] do
    member do
      # フォローとフォロワー一覧ページのルーティング
      get :following, :followers
    end

    # フォロー&アンフォローのためのルーティング
    resource :relationships, only: [:create, :destroy]
    #本の投稿数検索のルーティング
    get "book_count_search", to: "users#book_count_search"
  end

  resources :books do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  get "search" => "searches#search"
  get "book_search" => "homes#book_search"

  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  resources :groups do
    get 'join' => 'groups#join'
    get 'new/mail' => 'groups#new_mail'
    get 'send/mail' => 'groups#send_mail'
  end

end
Rails.application.routes.draw do
  get 'order/create', to: 'order#show_create', as: 'order_show_create'
  post 'order/create', to: 'order#create', as: 'order_create'
  get 'order/list'
  root 'menu#menu'
  get 'session/logout'
  get 'session/sendcode', to: 'session#show_sendcode', as: 'session_show_sendcode'
  post 'session/sendcode', to: 'session#sendcode', as: 'session_sendcode'
  get 'session/checkcode', to: 'session#show_checkcode', as: 'session_show_checkcode'
  post 'session/checkcode', to: 'session#checkcode', as: 'session_checkcode'
  # get 'menu/add_dish'
  post 'menu/add_dish/:id', to: 'menu#add_dish', as: 'menu_add_dish'
  post 'menu/remove_dish/:id', to: 'menu#remove_dish', as: 'menu_remove_dish'
  get 'menu/cart'
  # get ''
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test/input'
end

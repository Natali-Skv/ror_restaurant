Rails.application.routes.draw do
  root 'menu#get_menu'
  get 'session/logout'
  get 'session/sendcode', to: 'session#show_sendcode', as: 'session_show_sendcode'
  post 'session/sendcode', to: 'session#sendcode', as: 'session_sendcode'
  get 'session/checkcode', to: 'session#show_checkcode', as: 'session_show_checkcode'
  post 'session/checkcode', to: 'session#checkcode', as: 'session_checkcode'
  get 'menu/get_menu'
  # get 'menu/add_dish'
  post 'menu/add_dish/:id', to: 'menu#add_dish', as: 'menu_add_dish'
  get 'menu/remove_dish'
  get 'menu/get_cart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test/input'
end

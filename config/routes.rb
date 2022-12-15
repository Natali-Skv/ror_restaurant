Rails.application.routes.draw do
  root 'menu#get_menu'
  get 'menu/get_menu'
  get 'menu/add_dish'
  get 'menu/remove_dish'
  get 'menu/get_cart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test/input'
end

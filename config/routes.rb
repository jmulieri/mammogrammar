Rails.application.routes.draw do
  get 'search/:zip_code' => 'facilities#search'
  get 'near' => 'facilities#near'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

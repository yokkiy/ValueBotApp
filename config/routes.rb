Rails.application.routes.draw do
    post '/callback' => 'linebot#callback'
    root 'application#hello'  
end

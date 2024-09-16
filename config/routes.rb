# frozen_string_literal: true
HykuKnapsack::Engine.routes.draw do
  mount Hyrax::Engine, at: '/'
  get 'resources' => 'pages#show', key: 'resources'
  mount IiifPrint::Engine, at: '/'
end

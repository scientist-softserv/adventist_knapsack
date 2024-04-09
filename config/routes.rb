HykuKnapsack::Engine.routes.draw do
  get 'resources' => 'pages#show', key: 'resources'
  mount IiifPrint::Engine, at: '/'
end

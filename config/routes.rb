HykuKnapsack::Engine.routes.draw do

  authenticate :user, lambda { |u| u.is_superadmin || u.is_admin } do
    mount GoodJob::Engine => 'jobs'
  end

  get 'resources' => 'hyrax/pages#show', key: 'resources'
end

set :stage, :production
set :branch, 'master'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# change to your application domain name
set :server_name, 'nextjs-deployment.jameshuynh.com'

# change to your server IP and your username
server '52.221.255.167', user: 'ubuntu', roles: 'app', primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/www/#{fetch(:full_app_name)}"

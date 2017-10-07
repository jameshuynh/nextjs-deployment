set :application, 'nextjs-deployment' # change to your app name
set :deploy_user, 'ubuntu' # change to your server user
set :keep_releases, 5

# change to your git address
set :repo_url, 'git@github.com:jameshuynh/nextjs-deployment.git'

# for NVM
set :nvm_type, :user
set :nvm_node, 'v8.6.0' # change to your node version number
set :nvm_map_bins, %w[node npm yarn pm2 next]
set :nvm_custom_path, "/home/#{fetch(:deploy_user)}/.nvm/versions/node"
set :default_env,
    'PATH' => "/home/#{fetch(:deploy_user)}/.nvm/versions/node/v8.6.0/bin:$PATH"
set :nvm_path, "/home/#{fetch(:deploy_user)}/.nvm"

# share node_modules folder
set :linked_dirs, %w[node_modules]

# rubocop:disable BlockLength
# pm2 tasks
namespace :pm2 do
  task :start do
    on roles(:app) do
      within current_path do
        execute :npm, 'run build'
      end

      within shared_path do
        execute :pm2, 'start app.json'
      end
    end
  end

  task :restart do
    on roles(:app) do
      within current_path do
        execute :npm, 'run build'
      end

      within shared_path do
        execute :pm2, 'reload app.json'
      end
    end
  end

  task :stop do
    on roles(:app) do
      within shared_path do
        execute :pm2, 'stop app.json'
      end
    end
  end
end

namespace :deploy do
  after 'deploy:publishing', 'deploy:yarn_install'
  after 'deploy:publishing', 'deploy:restart'

  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'pm2:start'
      invoke 'deploy'
    end
  end

  task :yarn_install do
    on roles(:app) do
      within current_path do
        execute :yarn, 'install'
      end
    end
  end

  task :restart do
    invoke 'pm2:restart'
  end

  task :start do
    invoke 'pm2:start'
  end

  task :stop do
    invoke 'pm2:stop'
  end
end

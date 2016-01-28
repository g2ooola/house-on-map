# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'house-record'
set :repo_url, 'git@bitbucket.org:gsx1415/amero-house.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/applications/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/setting_privates.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :default_shell, '/bin/bash -l'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 10

# rvm1-capstrano3 hook ===
namespace :app do
  task :update_rvm_key do
    on roles(:all) do |host|
      execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
    end
  end
end
before "rvm1:install:rvm", "app:update_rvm_key"
before 'deploy', 'rvm1:install:rvm'  # install/update Rvm
before 'deploy', 'rvm1:install:ruby'  # install/update Ruby
before 'deploy', 'rvm1:alias:create'
before 'deploy', 'rvm1:install:gems'  # install/update gems from Gemfile into gemset

set :rvm1_ruby_version, "2.2.1"

# after 'deploy:reload', 'unicorn:reload'    # app IS NOT preloaded
# after 'deploy:restart', 'unicorn:restart'   # app preloaded
# after 'deploy:duplicate', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

set :bundle_without, %w{development test}.join(' ')
set :bundle_roles, :all
namespace :bundler do
  desc "Install gems with bundler."
  task :install do
    on roles fetch(:bundle_roles) do
      within release_path do
        execute :bundle, "install", "--without #{fetch(:bundle_without)}"
      end
    end
  end
end
before 'deploy:updated', 'bundler:install'

namespace :deploy do

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "link config files at first time of deploy"
  task :link_config do
    on roles(:app) do |host|
      execute "ln -nfs #{shared_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute "ln -nfs #{shared_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      execute "ln -nfs #{shared_path}/config/log_roration.conf /etc/logrotate.d/#{fetch(:application)}.conf"
    end
  end

  task :setup_config do
    on roles(:app) do |host|
      execute "mkdir -p #{shared_path}/config"
      # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"

      # put File.read("config/server_config/setting_privates.yml"), "#{shared_path}/config/setting_privates.yml"

      upload! "config/server_config/setting_privates.yml", "#{shared_path}/config/setting_privates.yml"
      upload! "config/server_config/database.yml", "#{shared_path}/config/database.yml"

      upload! "config/server_config/nginx.conf", "#{shared_path}/config/nginx.conf"
      upload! "config/server_config/unicorn_init.sh", "#{shared_path}/config/unicorn_init.sh"
      upload! "config/server_config/log_rotation.conf", "#{shared_path}/config/log_rotation.conf"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

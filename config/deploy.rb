# Change these

set :repo_url, 'git@github.com:DSKonstantin/spree_shop.git'
set :deploy_to, '/home/root/spree_shop'
set :user, 'root'
set :use_sudo, true
set :scm, :git
set :branch, :master
set :format, :pretty
set :log_level, :debug
set :pty, true
set :keep_releases, 1
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# CAPISTRANO RVM CONFIGS
set :default_env, :rvm_bin_path => '~/.rvm/bin'
set :rvm_ruby_version, '2.3.0@spree_shop'

# CAPISTRANO BUNDLER CONFIGS
set :bundle_flags, '--deployment'

# namespace :deploy do
#   desc 'DROP DATABASE BEFORE DEPLOY'
#   task :refresh_database => [:set_rails_env] do
#     on primary fetch(:migration_role) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, 'app:destroy_pg_sessions'
#           execute :rake, 'db:drop'
#           execute :rake, 'db:create'
#         end
#       end
#     end
#   end
#   before 'deploy:migrate', 'deploy:refresh_database'
#
#   desc 'Runs rake db:seed for update dictionaries'
#   task :seed => [:set_rails_env] do
#     on primary fetch(:migration_role) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, 'db:seed'
#         end
#       end
#     end
#   end
#   after 'deploy:migrate', 'deploy:seed'
#
#   desc 'Runs rake demo:seed for seeding demo data'
#   task :demo_seed => [:set_rails_env] do
#     on primary 'db' do
#       within release_path do
#         with :rails_env => fetch(:rails_env) do
#           execute :rake, 'demo:seed'
#         end
#       end
#     end
#   end
#   after 'deploy:seed', 'deploy:demo_seed'
# end

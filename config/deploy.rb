# set :repo_url, 'git@github.com:DSKonstantin/spree_shop.git'
# set :deploy_to, '/home/root/apps/spree_shop'
# set :user, 'root'
# set :use_sudo, true
# set :scm, :git
# set :branch, :master
# set :format, :pretty
# set :log_level, :debug
# set :pty, true
# set :keep_releases, 1
# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
#
# # CAPISTRANO RVM CONFIGS
# set :default_env, :rvm_bin_path => '~/.rvm/bin'
# set :rvm_ruby_version, '2.3.0@spree_shop'
#
# # CAPISTRANO BUNDLER CONFIGS
# set :bundle_flags, '--deployment'
#
# namespace :deploy do
#   # desc 'DROP DATABASE BEFORE DEPLOY'
#   # task :refresh_database => [:set_rails_env] do
#   #   on primary fetch(:migration_role) do
#   #     within release_path do
#   #       with rails_env: fetch(:rails_env) do
#   #         execute :rake, 'app:destroy_pg_sessions'
#   #         execute :rake, 'db:drop'
#   #         execute :rake, 'db:create'
#   #       end
#   #     end
#   #   end
#   # end
#   # before 'deploy:migrate', 'deploy:refresh_database'
# #
# #   desc 'Runs rake db:seed for update dictionaries'
# #   task :seed => [:set_rails_env] do
# #     on primary fetch(:migration_role) do
# #       within release_path do
# #         with rails_env: fetch(:rails_env) do
# #           execute :rake, 'db:seed'
# #         end
# #       end
# #     end
# #   end
# #   after 'deploy:migrate', 'deploy:seed'
# #
# #   desc 'Runs rake demo:seed for seeding demo data'
# #   task :demo_seed => [:set_rails_env] do
# #     on primary 'db' do
# #       within release_path do
# #         with :rails_env => fetch(:rails_env) do
# #           execute :rake, 'demo:seed'
# #         end
# #       end
# #     end
# #   end
# #   after 'deploy:seed', 'deploy:demo_seed'
# #   task :copy_config do
# #     on release_roles :app do |role|
# #       fetch(:linked_files).each do |linked_file|
# #         user = role.user + "@" if role.user
# #         hostname = role.hostname
# #         linked_files(shared_path).each do |file|
# #           run_locally do
# #             execute :rsync, "config/#{file.to_s.gsub(/.*\/(.*)$/,"\\1")}", "#{user}#{hostname}:#{file.to_s.gsub(/(.*)\/[^\/]*$/, "\\1")}/"
# #           end
# #         end
# #       end
# #     end
# #   end
#
# end
# # before "deploy:check:linked_files", "deploy:copy_config"


set :repo_url,        'git@github.com:DSKonstantin/spree_shop.git'
set :application,     'spree_shop'
set :user,            'root'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes ssh console
require 'capistrano/console'

# Includes rails console
require 'capistrano/rails/console'

# Includes default deployment tasks
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/rails'
require 'capistrano/puma'
# require 'whenever/capistrano'

# capistrano-rails
require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
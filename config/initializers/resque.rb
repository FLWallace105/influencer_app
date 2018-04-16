Resque.logger.level = Logger::DEBUG
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))

rails_root = Rails.root
rails_env = Rails.env
config_file = rails_root + 'config/resque.yml'

resque_config = YAML::load(ERB.new(IO.read(config_file)).result)
Resque.redis = resque_config[rails_env]

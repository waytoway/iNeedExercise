# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
  
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  errors = ActiveRecord::Errors.default_error_messages   
  errors[:taken] = '已经被使用'  
  errors[:blank] = '不能为空' 
  ActiveRecord::Errors.default_error_messages[:inclusion] = " 字段没有包括在列表内！" 
ActiveRecord::Errors.default_error_messages[:exclusion] = " 字段已被保存过了！" 
ActiveRecord::Errors.default_error_messages[:invalid] = " 字段是无效的！" 
ActiveRecord::Errors.default_error_messages[:confirmation] = " 字段不匹配的信息！" 
ActiveRecord::Errors.default_error_messages[:accepted] = " 字段必须接受此选项！" 
ActiveRecord::Errors.default_error_messages[:empty] = " 字段不能为空！" 
ActiveRecord::Errors.default_error_messages[:blank] = " 字段不能为空！" 
ActiveRecord::Errors.default_error_messages[:too_long] = " 字段太长了(最大是 %d 个英文字符)！" 
ActiveRecord::Errors.default_error_messages[:too_short] = " 字段太短了(最小是 %d 个英文字符)！" 
ActiveRecord::Errors.default_error_messages[:wrong_length] = " 字段长度有错误(应该是 %d 个英文字符)！" 
ActiveRecord::Errors.default_error_messages[:taken] = " 字段已经选择过了！" 
ActiveRecord::Errors.default_error_messages[:not_a_number] = " 字段不是个数字！" 
end
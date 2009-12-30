set :application, "berlin"
set :domain, "berlin.kingaxis.com"
set :role_domain, "server.kingaxis.com"
set :deploy_to, "/var/lighttpd-www/hosts/#{domain}"

# SCM
set :scm, :subversion
set :repository,  "http://svn.kingaxis.com:81/berlin/trunk/berlin"
set :scm_user, "deploy"
set :scm_password, Proc.new { Capistrano::CLI.password_prompt("SVN[#{scm_user}@#{repository}] password: ") }

# DB
set :db_host, "mysql.kingaxis.com"
set :db_adapter, "mysql"
set :db_encoding, "utf8"
set :db_reconnect, "false"
set :db_schema, "berlin"
set :db_pool, "5"
set :db_username, "berlin"
set :db_password, proc { Capistrano::CLI.password_prompt("DB[#{db_username}@#{db_schema}] password: ") }
set :db_socket, "/var/lib/mysql/mysql.sock"
set :database_yml_template, "database.yml"

# Interpreter
set :dispatch_files, ["dispatch.fcgi", "dispatch.cgi", "dispatch.rb"]
set :interpreter, "/usr/local/bin/ruby"

# Roles
role :db, "root@mysql.kingaxis.com:12031", :primary => true
set :use_sudo, false

# Deployment
namespace :deploy do
  
  desc "Backup the database"
  task :backup_database, :roles => :db do
    backup_filename = "#{db_schema}_#{Time.now.strftime("%Y%M%d_%H%m%S")}.sql"
    run "mysqldump --user=#{db_username} --password=#{db_password} --host=#{db_host} #{db_schema} > /tmp/#{backup_filename}"
    run "bzip2 /tmp/#{backup_filename}"
    run "mv /tmp/#{backup_filename}.bz2 /backup/mysql/#{db_schema}/"
  end
  
  desc "Creates the database configuration on the fly"
  task :create_database_configuration, :roles => :db do
    require "yaml"
    
    db_config = YAML::load_file("config/#{database_yml_template}")
    db_config.delete('test')
    db_config.delete('development')
    
    db_config['production']['adapter'] = "#{db_adapter}"
    db_config['production']['encoding'] = "#{db_encoding}"
    db_config['production']['reconnect'] = "#{db_reconnect}"
    db_config['production']['database'] = "#{db_schema}"
    db_config['production']['pool'] = "#{db_pool}"
    db_config['production']['username'] = "#{db_username}"
    db_config['production']['password'] = db_password
    db_config['production']['socket'] = "#{db_socket}"
    
    put YAML::dump(db_config), "#{release_path}/config/database.yml", :mode => 0664
  end
  
  desc "Repair interpreter path in dispatch file"
  task :repair_interpreter, :roles => :db do
    dispatch_files.each do |dispatch_file|
      dispatch_content = ""
      open("public/#{dispatch_file}") { |f| dispatch_content = f.read }
      dispatch_content = dispatch_content.sub("\#\!\/usr\/bin\/ruby", "\#\!#{interpreter}")
      put dispatch_content, "#{release_path}/public/#{dispatch_file}", :mode => 0755
    end
  end
  
  after "deploy:update_code", "deploy:backup_database", "deploy:create_database_configuration", "deploy:repair_interpreter" 
  
#  desc "Creates attachments link"
#  task :link_attachments, :roles => :db do
#    run "rm -rf #{deploy_to}/current/public/attachments"
#    run "ln -s #{deploy_to}/shared/attachments/ #{deploy_to}/current/public/"
#  end
  
  after "deploy:symlink", "deploy:link_attachments"
  
  desc "Set permission for web server user"
  task :repair_permission, :roles => :db do
    run "chown -R lighttpd:lighttpd #{deploy_to}"
    run "chmod -fR 755 #{deploy_to}/current/script/*"
    run "chmod -fR 755 #{deploy_to}/current/public/dispatch.*"
  end
  
  before "deploy:restart", "deploy:repair_permission"
  
  desc "Restart web server"
  task :restart, :roles => :db do
    run "service lighttpd restart"
  end
end

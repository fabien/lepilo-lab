# This file is specifically setup for use with the merb-auth plugin.
# This file should be used to setup and configure your authentication stack.
# It is not required and may safely be deleted.
#
# To change the parameter names for the password or login field you may set either of these two options
#
# Merb::Plugins.config[:"merb-auth"][:login_param]    = :email 
# Merb::Plugins.config[:"merb-auth"][:password_param] = :my_password_field_name

Merb::Slices::config[:merb_auth_slice_password][:path_prefix] = 'auth'

# The following is a bare-bones/stub User model that reads users from a YAML file.
# Just provide your own User model and backend-storage and remove the code
# within the following if/else block - see merb-auth-slice-password for info.
#
# The initial format of entries in Merb.root / system / users.yml is as follows:
#
# - login: lepilo
#   password: sekrit
#
# The first time the users file is encountered it will encrypt the passwords.

if File.exists?(USERS_FILE = Merb.root / 'system' / 'users.yml')

  class User

    attr_accessor :id, :login, :password, :crypted_password, :salt
  
    def initialize(data)
      @login            = @id = data['login']
      @salt             = data['salt']
      @password         = data['password']
      @crypted_password = data['crypted_password']
      self.encrypt_password
    end
    
    def new_record?
      @crypted_password.blank?
    end
    
    def data
      { 'login' => login, 'crypted_password' => crypted_password, 'salt' => salt }
    end
  
    def self.get(id)
      self.all.find { |user| user.id == id }
    end
    
    def self.authenticate(login, password)
      @u = get(login)
      @u && @u.authenticated?(password) ? @u : nil
    end
  
    def self.all
      @@users ||= begin
        users = YAML.load_file(USERS_FILE).map { |u| self.new(u) }
        File.open(USERS_FILE, 'w+') { |f| f.write(YAML.dump(users.map { |u| u.data })) }
        users.each { |u| u.password = nil }
        users
      end 
    end
  
  end

end

# The following is the default merb-auth setup.

begin
  # Sets the default class for authentication.  This is primarily used for 
  # Plugins and the default strategies
  Merb::Authentication.user_class = User 
  
  # Mixin the salted user mixin
  require 'merb-auth-more/mixins/salted_user'
  Merb::Authentication.user_class.class_eval{ include Merb::Authentication::Mixins::SaltedUser }
    
  # Setup the session serialization
  class Merb::Authentication

    def fetch_user(session_user_id)
      Merb::Authentication.user_class.get(session_user_id)
    end

    def store_user(user)
      user.nil? ? user : user.id
    end
    
  end
  
rescue
  Merb.logger.error <<-TEXT
  
    You need to setup some kind of user class with merb-auth.  
    Merb::Authentication.user_class = User
    
    If you want to fully customize your authentication you should use merb-core directly.  
    
    See merb/merb-auth/setup.rb and strategies.rb to customize your setup

    TEXT
end
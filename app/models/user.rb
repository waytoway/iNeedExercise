require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_accessor :current_password
  attr_accessor :protect_question
  attr_accessor :answer
  
  # Max & min lengths for all fields 
  SCREEN_NAME_MIN_LENGTH = 4 
  SCREEN_NAME_MAX_LENGTH = 20 
  PASSWORD_MIN_LENGTH = 4 
  PASSWORD_MAX_LENGTH = 40 
  EMAIL_MAX_LENGTH = 50 
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH 
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH 

  # Text box sizes for display in the views 
  SCREEN_NAME_SIZE = 20 
  PASSWORD_SIZE = 10 
  EMAIL_SIZE = 30

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    
    puts encrypt(password)
    puts password
    puts salt
    puts crypted_password
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
    self.current_password = nil
  end
  
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]
    crypted_password == encrypt(current_password) 
  end

  def password_errors(params)
    puts "ddddddddddddddddddddd currentpassword wrong"
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    if(correct_password?(params))
      return
    else
      errors.add(:current_password, "is incorrect")
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end

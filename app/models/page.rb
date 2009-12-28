class Page < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => 'parent_id', :dependent => :destroy
  
  named_scope :root, :conditions => {:parent_id => nil}
  named_scope :common, :conditions => {:is_admin => 0}
  named_scope :admin, :conditions => {:is_admin => 1}
  named_scope :before_login, :conditions => {:is_login => 0}
  named_scope :after_login, :conditions => {:is_login => 1}
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => "parent_id"
  
  
  def self.navigator(user)
    h = {}
    h[:is_login] = 0 unless user.nil?
    h[:is_admin] = 0 unless User.isAdmin?(user)
    Page.root.find(:all, :conditions => h)
  end
  
  def page_url
    self.url.blank? ? "/pages/display/#{self.id}" : self.url
  end
end

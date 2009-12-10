class Page < ActiveRecord::Base
  belongs_to :page
  has_many :pages
end

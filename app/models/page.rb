class Page < ActiveRecord::Base
  #higher_page表示父页面
  belongs_to :higher_page, :class_name => "Page", :foreign_key => "parent_id"
  #lower_pages表示子页面集合
  has_many :lower_pages, :class_name => "Page", :foreign_key => "parent_id"
end

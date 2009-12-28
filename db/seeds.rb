# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

#add admin user login:admin, password:1111
User.create(:login => "admin",:email => "admin@51duanlian.com",:crypted_password => "f584064a81a17773209986b0c81cc94bdf1dd163",
            :salt => "5c6c2e4f32a1c8984cbc2d4a2e74503131986912",:is_admin => 1,:cell => "12345678901")

#
Page.create(:title => '首页', :url => "/main")
Page.create(:title => '注册', :url => "/account/signup",:is_login => 1)
Page.create(:title => '关于我们')
Page.create(:title => '联系我们')
Page.create(:title => '帮助中心')
Page.create(:title => '我的锻炼',:url => "/user")
Page.create(:title => '页面管理', :url => "/pages", :is_admin => 1)
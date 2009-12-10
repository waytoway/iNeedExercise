# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091210205839) do

  create_table "cities", :force => true do |t|
    t.string "name"
  end

  create_table "festivlogs", :force => true do |t|
    t.string   "festival",   :limit => 500
    t.string   "interval"
    t.string   "updater"
    t.datetime "created_at"
  end

  create_table "pages", :force => true do |t|
    t.string  "title"
    t.string  "content"
    t.integer "parent_id"
  end

  create_table "protect_questions", :force => true do |t|
    t.string "question"
  end

  create_table "regions", :force => true do |t|
    t.string  "name"
    t.integer "city_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "en_name"
    t.string   "cn_name"
    t.datetime "created_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "smslogs", :force => true do |t|
    t.string   "book",       :limit => 500
    t.string   "unbook",     :limit => 500
    t.string   "updater"
    t.datetime "created_at"
  end

  create_table "t_business_info", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID",                   :null => false
    t.string  "NAME",         :limit => 50
    t.string  "BANK",         :limit => 50
    t.string  "BANK_ACCOUNT", :limit => 20
    t.string  "OWNER",        :limit => 10
    t.string  "OWNER_MOBILE", :limit => 11
  end

  add_index "t_business_info", ["VENUE_ID"], :name => "FK_Reference_8"

  create_table "t_card_discount", :force => true do |t|
    t.string  "card_no",       :limit => 50
    t.integer "discount_rate", :limit => 8
    t.string  "discount_time", :limit => 10
  end

  create_table "t_card_type", :force => true do |t|
    t.string  "type_name",      :limit => 50
    t.integer "money_amount",   :limit => 8
    t.date    "indate"
    t.integer "discount_rate",  :limit => 8
    t.string  "discount_time",  :limit => 10
    t.string  "DISCOUNT_TYPE",  :limit => 2
    t.float   "DISCOUNT_PRICE", :limit => 10
  end

  create_table "t_card_usage_record", :id => false, :force => true do |t|
    t.integer  "id",               :limit => 8,  :null => false
    t.integer  "venue_id",         :limit => 8
    t.integer  "card_id",          :limit => 8
    t.string   "card_no",          :limit => 20
    t.datetime "usage_date"
    t.string   "usage_time_slice", :limit => 20
    t.string   "signature",        :limit => 20
    t.float    "option_total",     :limit => 10
    t.float    "balance",          :limit => 10
    t.string   "usage_type",       :limit => 10
  end

  create_table "t_field_badmintoon", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID"
    t.date    "CREATE_DATE"
    t.string  "FIELD_CODE",      :limit => 50
    t.string  "NAME",            :limit => 50
    t.string  "ENV_TYPE",        :limit => 20
    t.string  "STATUS",          :limit => 20
    t.integer "ADVANCE"
    t.date    "ISSUE_LAST_DATE"
  end

  add_index "t_field_badmintoon", ["VENUE_ID"], :name => "FK_Reference_7"

  create_table "t_field_badmintoon_activity", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID"
    t.integer "FIELD_ID"
    t.string  "FIELD_TYPE",   :limit => 20
    t.string  "FIELD_NAME",   :limit => 50
    t.string  "PERIOD",       :limit => 50
    t.integer "PRICE"
    t.integer "ORDER_ID",     :limit => 8
    t.string  "ACTIVITY",     :limit => 50
    t.time    "FROM_TIME"
    t.time    "TO_TIME"
    t.string  "ORDER_USER",   :limit => 10
    t.date    "USABLE_DATE"
    t.string  "AUTHENTICODE", :limit => 10
    t.string  "VERIFICATION", :limit => 1
  end

  add_index "t_field_badmintoon_activity", ["FIELD_ID"], :name => "FK_Reference_4"
  add_index "t_field_badmintoon_activity", ["ORDER_ID"], :name => "FK_Reference_6"

  create_table "t_field_badmintoon_basic_price", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID",         :limit => 8
    t.integer "LOWEST_TIME"
    t.string  "LOWEST_TIME_TYPE", :limit => 4
    t.integer "PRICE"
    t.string  "FROM_TIME",        :limit => 5
    t.string  "TO_TIME",          :limit => 5
  end

  create_table "t_field_badmintoon_special_price", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID",         :limit => 8
    t.integer "LOWEST_TIME"
    t.string  "LOWEST_TIME_TYPE", :limit => 4
    t.integer "PRICE"
    t.string  "FROM_TIME",        :limit => 5
    t.string  "TO_TIME",          :limit => 5
    t.date    "FROM_DATE"
    t.date    "END_DATE"
  end

  create_table "t_field_badmintoon_weekend_price", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID",         :limit => 8
    t.integer "LOWEST_TIME"
    t.string  "LOWEST_TIME_TYPE", :limit => 4
    t.integer "PRICE"
    t.string  "FROM_TIME",        :limit => 5
    t.string  "TO_TIME",          :limit => 5
  end

  create_table "t_field_order", :primary_key => "ID", :force => true do |t|
    t.integer   "VENUE_ID",       :limit => 8
    t.string    "CONTACT",        :limit => 10
    t.integer   "CARD_ID",        :limit => 8
    t.string    "USER_CODE",      :limit => 10
    t.string    "PHONE",          :limit => 13
    t.boolean   "PAYMENT_STATUS"
    t.timestamp "BOOK_TIME",                    :null => false
    t.timestamp "PAYMENT_TIME",                 :null => false
    t.float     "PAYMENT_SUM",    :limit => 10
    t.float     "STANDARD_PRICE", :limit => 10
    t.string    "PAYMENT_STYLE",  :limit => 10
  end

  create_table "t_member_card", :primary_key => "ID", :force => true do |t|
    t.integer  "VENUE_ID",     :limit => 8
    t.string   "CARD_NUMBER",  :limit => 10
    t.string   "NAME",         :limit => 15
    t.float    "BALANCE",      :limit => 10
    t.string   "MOBILE_PHONE", :limit => 11
    t.datetime "CREATE_DATE"
    t.string   "ID_NO",        :limit => 50
    t.string   "ADDRESS",      :limit => 200
    t.integer  "CARD_TYPE_ID", :limit => 8
  end

  create_table "t_sys_user", :primary_key => "ID", :force => true do |t|
    t.string "PASSWORD",     :limit => 16
    t.string "NAME",         :limit => 10
    t.string "PHONE",        :limit => 13
    t.string "MOBILE_PHONE", :limit => 11
    t.string "EMAIL",        :limit => 30
    t.string "CITY",         :limit => 30
    t.string "DISTRICT",     :limit => 30
    t.string "ADDRESS",      :limit => 100
  end

  create_table "t_venue_info", :primary_key => "ID", :force => true do |t|
    t.string "VENUE_NAME",   :limit => 50
    t.string "PHONE",        :limit => 13
    t.string "FAX",          :limit => 13
    t.string "ADRESS",       :limit => 100
    t.string "CITY",         :limit => 20
    t.string "DISTRICT",     :limit => 20
    t.string "AREA",         :limit => 20
    t.string "ZIPCODE",      :limit => 6
    t.string "OPEN_TIME",    :limit => 5
    t.string "CLOSE_TIME",   :limit => 5
    t.string "CONTACT",      :limit => 10
    t.string "CELL",         :limit => 11
    t.string "EMAIL",        :limit => 30
    t.text   "INTRADUCTION", :limit => 16777215
    t.string "PHOTO_URL",    :limit => 300
    t.string "AUTHENTICODE", :limit => 10
    t.string "VERIFICATION", :limit => 1
  end

  create_table "t_venue_member_info", :primary_key => "ID", :force => true do |t|
    t.string   "VENUE_PASSWORD",   :limit => 50
    t.string   "VENUE_REPASSWORD", :limit => 50
    t.string   "VENUE_NAME",       :limit => 50
    t.string   "VENUE_ICNO",       :limit => 50
    t.string   "CITY",             :limit => 20
    t.string   "DISTRICT",         :limit => 20
    t.string   "ADRESS",           :limit => 100
    t.string   "PHONE1",           :limit => 20
    t.string   "PHONE2",           :limit => 20
    t.string   "FAX",              :limit => 20
    t.string   "PEOPLE_NUM",       :limit => 40
    t.string   "BUSSINESS_TIMEI",  :limit => 30
    t.string   "TIMEI_PRICE1",     :limit => 40
    t.string   "TIMEI_PRICE2",     :limit => 40
    t.string   "TIMEI_PRICE3",     :limit => 40
    t.string   "TIMEI_PRICE4",     :limit => 40
    t.string   "MON_FRI",          :limit => 40
    t.string   "WEEKEND",          :limit => 40
    t.string   "MEMBER_YN",        :limit => 1,   :default => "N", :null => false
    t.string   "MEMBER_PRICE",     :limit => 50
    t.datetime "created_at"
  end

  create_table "t_venue_user", :primary_key => "ID", :force => true do |t|
    t.integer "VENUE_ID"
    t.string  "USERNAME", :limit => 16
    t.string  "PASSWORD", :limit => 16
    t.string  "STATUS",   :limit => 2
  end

  add_index "t_venue_user", ["VENUE_ID"], :name => "FK_Reference_5"

  create_table "tests", :force => true do |t|
    t.string "email"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "cell",                      :limit => 13
    t.boolean  "is_admin"
    t.integer  "question_id"
    t.string   "answer"
  end

  create_table "venueusurls", :force => true do |t|
    t.string   "venueusurl",  :limit => 500
    t.string   "creater"
    t.datetime "created_at"
    t.string   "description", :limit => 500, :default => "", :null => false
    t.integer  "venue_id",                   :default => 0,  :null => false
  end

end

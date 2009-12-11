class TFieldBadmintoon < ActiveRecord::Base
  set_table_name "t_field_badmintoon"
  has_many :t_field_order,:class_name=>"TFieldOrder",:foreign_key=>"field_id",:primary_key=>"ID"
end

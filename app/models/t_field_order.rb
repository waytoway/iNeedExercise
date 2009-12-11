class TFieldOrder < ActiveRecord::Base
  set_table_name "t_field_order"
  belongs_to :t_field_badmintoon,:class_name=>"TFieldBadmintoon",:foreign_key=>"field_id",:primary_key=>"ID"
  
end

class TCardUsageRecord < ActiveRecord::Base
  set_table_name "t_card_usage_record"
  
  def self.add_record
    @last = TCardUsageRecord.find(:last)
    @count = @last[:id]
    cardUsageRecord = TCardUsageRecord.new
    cardUsageRecord.id = @count+1
    cardUsageRecord.venue_id = session[:venue_id]
    cardUsageRecord.card_id = @card.ID
    cardUsageRecord.card_no = @card.CARD_NUMBER
    cardUsageRecord.usage_date = session[:pay_usable_date]
    cardUsageRecord.usage_time_slice = session[:pay_from_time]+"-"+session[:pay_to_time]
    cardUsageRecord.option_total = session[:price]
    cardUsageRecord.usage_type = "扣款"
    cardUsageRecord.balance=@card.BALANCE
    cardUsageRecord.save
  end
end

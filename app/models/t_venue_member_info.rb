class TVenueMemberInfo < ActiveRecord::Base
  set_table_name "t_venue_member_info"
  
  def self.new_venue(params,id)
    venue_member_info = self.new
    venue_member_info.ID = id 
    venue_member_info.VENUE_NAME = params[:venue_name] unless params[:venue_name] == nil
    venue_member_info.VENUE_ICNO = params[:venue_icno] unless params[:venue_icno] == nil
    venue_member_info.CITY = params[:city] unless params[:city] == nil
    venue_member_info.DISTRICT = params[:region] unless params[:region] == nil
    venue_member_info.ADRESS = params[:address] unless params[:address] == nil
    venue_member_info.PHONE1 = params[:tel1] unless params[:tel1] == nil
    venue_member_info.PHONE2 = params[:tel2] unless params[:tel2] == nil
    venue_member_info.FAX = params[:fax] unless params[:fax] == nil
    venue_member_info.PEOPLE_NUM = params[:personNum] unless params[:personNum] == nil
    venue_member_info.BUSSINESS_TIMEI = params[:openTime] unless params[:openTime] == nil
    venue_member_info.TIMEI_PRICE1 = params[:intervalPrice1] unless params[:intervalPrice1] == nil
    venue_member_info.TIMEI_PRICE2 = params[:intervalPrice2] unless params[:intervalPrice2] == nil
    venue_member_info.TIMEI_PRICE3 = params[:intervalPrice3] unless params[:intervalPrice3] == nil
    venue_member_info.TIMEI_PRICE4 = params[:intervalPrice4] unless params[:intervalPrice4] == nil
    venue_member_info.MON_FRI = params[:monToFri] unless params[:monToFri] == nil
    venue_member_info.WEEKEND = params[:weekend] unless params[:weekend] == nil
    if params[:member] == 'yes'
      venue_member_info.MEMBER_YN = 'Y'
    else
      venue_member_info.MEMBER_PRICE = params[:member_price] unless params[:member_price] == nil
    end
    @cur_time = Time.now
    venue_member_info.created_at = @cur_time.strftime("%Y-%m-%d %H:%M:%S") 
    return venue_member_info
  end
end

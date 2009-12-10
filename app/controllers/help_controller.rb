class HelpController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  def index
#    a=User.find(1)
#    puts "aaaaaaaaaaaaaaaa"
#    puts a.t_member_cards[0][:ID]
#    puts a.t_member_cards[0].t_card_usage_records.length
#    a=TMemberCard.find(1)
#    puts "aaaaaaaaaaaaaaaa"
#    puts a.t_card_usage_records[0][:card_no]
  end
end

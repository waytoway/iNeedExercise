class HelpController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  
  def index
    @request = Kuaiqian::Request.new('产品名称', # 产品名称
    1, # 订单ID，必须全局唯一
    Time.now, # 订单生成时间，格式为20091104174132
    4500, # 订单金额，以分为单位
            'http://return', # 通知地址，用户支付成功后快钱会通过此地址通知商户支付结果
            '00', # 支付类型，00显示所有方式，10只显示银行卡方式，11只显示电话银行方式，12只显示快钱帐户支付方式，13只显示线下方式
            'attach') #自定义数据，会在返回URL中原样返回
    redirect_to @request.url
  end
end

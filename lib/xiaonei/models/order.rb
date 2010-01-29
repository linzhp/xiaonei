module Xiaonei
  class Order < Model

    def self.elm_name
      "pay_regOrder_response"
    end

    def self.attr_names
      [
       :session_key,
       :uid,
       :order_id,
       :amount,
       :token,
       :redirect_url
      ]
    end

    for a in attr_names
      attr_accessor a
    end

  end
end


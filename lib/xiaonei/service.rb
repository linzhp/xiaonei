require 'net/http'
require 'pp'
module Xiaonei
  class Service
    DEBUG = false
    
    def post(params)
      pp "### Posting Params: #{params.inspect}" if DEBUG
      # 在Ruby 1.9中Params 的hash key必须转成string
      str_params = Hash.new
      params.keys.each do |k|
      	str_params[k.to_s] = params[k]
      end
      Net::HTTP.post_form(url, str_params)
    end
    
    private
    def url
      URI.parse(ENV['XIAONEI_REST_SERVER'])
    end
  end
end

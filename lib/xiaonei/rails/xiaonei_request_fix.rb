module ::ActionController

  class AbstractRequest
  
    def request_method_with_xiaonei
      if parameters["xn_sig_method"]=="get" and parameters[:_method].blank?
        parameters[:_method]="GET"
      end
      request_method_without_xiaonei
    end
    if new.methods.include?("request_method")
      alias_method_chain :request_method, :xiaonei
    end



  end
end

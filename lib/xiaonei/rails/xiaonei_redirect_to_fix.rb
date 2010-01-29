module ::ActionController
 include Xiaonei::Rails::Helpers
  class Base
  
    def redirect_to_with_xiaonei(*args)
      options = args.first.is_a?(Hash) ? args.first : args.last
      if  options[:xiaonei]  and options[:xiaonei] == false
         redirect_to_without_xiaonei
      else
        
         render :text=> xn_redirect(url_for(options))         
      end
    end
    alias_method_chain :redirect_to, :xiaonei
  end
end

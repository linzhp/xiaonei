module ::ActionController
  class AbstractRequest                         
    def relative_url_root
      Xiaonei.path_prefix
    end                                         
  end
  
  class UrlRewriter
    RESERVED_OPTIONS << :canvas

    def link_to_canvas?(params, options)
      option_override = options[:canvas]
      return false if option_override == false # important to check for false. nil should use default behavior
      option_override ||  @request.parameters[:xn_sig_in_iframe] != "1"
    end
  
    def rewrite_url_with_xiaonei(*args)
      options = args.first.is_a?(Hash) ? args.first : args.last
      is_link_to_canvas = link_to_canvas?(@request.request_parameters, options)
      if is_link_to_canvas && !options.has_key?(:host) 
        options[:host] = Xiaonei.canvas_server_base
      end 
      options.delete(:canvas)

      Xiaonei.request_for_canvas(is_link_to_canvas) do
        rewrite_url_without_xiaonei(*args)
      end
    end
    
    alias_method_chain :rewrite_url, :xiaonei
  end

  module ::ActionView
    module Helpers
      module UrlHelper
        def current_page?(options)
          url_string = CGI.escapeHTML(url_for(options))
          request = @controller.request
          # We ignore any extra parameters in the request_uri if the
          # submitted url doesn't have any either.  This lets the function
          # work with things like ?order=asc
          if url_string.index("?")
            request_uri = request.request_uri
          else
            request_uri = request.request_uri.split('?').first
          end
          if url_string =~ /^\w+:\/\//
            url_string == "#{request.protocol}#{request.host_with_port}#{request_uri}"
          else
            url_string == Xiaonei.xiaonei_path_prefix+request_uri
          end
        end
      end
    end
  end
end

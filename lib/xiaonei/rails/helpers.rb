# encoding: utf-8

include ActionView::Helpers::TagHelper
module Xiaonei
  module Rails
    module Helpers

      def xn_form_fields_in_iframe
        fields = %w{xn_sig_in_iframe xn_sig_time xn_sig_added xn_sig_user xn_sig_session_key xn_sig_expires xn_sig_api_key xn_sig_app_id} 
        fields.map{ |key| hidden_field_tag(key,params[key])}.join
      end


      # options are
      # *linked* default is true
      def xn_name(uid,options={})
        options = {:linked=>false}.merge options
        options[:uid] = uid
        tag("xn:name",options)
      end

      # options are
      # *linked* default is true
      def xn_profile_pic(uid,options={})
        options = {:size=>:normal}.merge options
        options[:uid] = uid
        tag "xn:profile-pic",options
      end

      # <% xn_if_is_user "aotianlong,david" do %>
      #   this content will show on current user is aotianlong or david
      # <% end %>
      def xn_if_is_user(uid,&block)
        uid = uid.join(",") if uid.is_a?(Array)
        options = {:uid=>uid}
        content = capture(&block)
        concat(content_tag("xn:if-is-user",content,options),block.binding)
      end

      #xn-js-string   
      def xn_js_string(var,&block)
        options = {:var=>var}
        content = capture(&block)
        concat(content_tag("xn:js-string",content,options),block.binding)
      end

      # <% xn_is_app_user do %>
      #  this content will show on current user is app user
      # <% end %>
      def xn_if_is_app_user(uid,&block)
        options = {}
        options[:uid] = uid if uid
        content = capture(&block)
        concat(content_tag("xn:if-is-app-user",content,options),block.binding)
      end

      def xn_wide(&block)
        content = capture(&block)
        concat(content_tag("xn:wide",content),block.binding)
      end

      def xn_narrow
        content = capture(&block)
        concat(content_tag("xn:narrow",content),block.binding)
      end

      #  Required    Name    Type    Description
      #  required  swfsrc  string  flash的url，url注意必须是决对路径。(default value is [1]; 注意flash不能在profile pages使用.)
      #  optional  imgsrc  string  图片的url(只接受.gif和.jpg格式).
      #  height  int   flash和图片的高度.
      #  width   int   flash和图片的宽度.
      #  imgstyle  string  图片的style属性
      #  imgclass  string  图片的class属性
      #  flashvars   string  URL-encoded编码的flash var
      #  swfbgcolor  string  hex-encoded编码的flash背景色
      #  waitforclick  bool  自动播放flash(默认false)
      #  salign  string  The salign attribute from normal Flash <embed>. Specify t (top), b (bottom) l (left), r (right) or a combination (tl, tr, bl, br)
      #  loop  bool  是否连续播放. 值: true, false
      #  quality   string  flash显示质量. 值 high, medium , low.
      #  scale   string  flash缩放. 值 showall, noborder, exactfit
      #  align   string  对齐. 值 left, center , right
      #  wmode   string  flash透明性. Specify transparent, opaque or window. (default value is transparent)
      def xn_swf(swfsrc,options={})
        options[:swfsrc] = swfsrc
        tag("xn:swf",options)
      end

      def xn_iframe(src,options={})
        options[:src] = ActionController::Base.asset_host + src
        tag("xn:iframe",options)
      end

      def xn_else(&block)
        content = capture(&block)
        concat(content_tag("xn:else",content),block.binding)
      end

      def xn_if(value,&block)
        content = capture(&block)
        options = {:value=>value}
        concat(content_tag("xn:if",content,options),block.binding)
      end
       
      def xn_invite_form(options={},&block)
        content = capture(&block)
        concat(content_tag("xn:invite-form",content,options),block.binding)
      end


      def xn_if_online(uid,&block)
        content = capture(&block)
        options = {:uid=>uid}
        concat(content_tag("xn:if-online",content,options),block.binding)
      end
      
      def xn_talk_to(uid,&block)
        content = capture(&block)
        options = {:uid=>uid}
        concat(content_tag("xn:talk-to",content,options),block.binding)
      end



      # Required    Name    Type    Description
      # optional  username  string  提交用户id的表单元素的name。(默认是friend_selector_name)
      # nickname  string  提交用户昵称的表单元素的name。(默认是friend_selector_nickname)
      # see http://developers.51.com/wiki/index.php?title=xn:friend-selector
      def xn_friend_selector(options={})
        tag "xn:friend-selector",options
      end

      # Required    Name    Type    Description
      # optional  name  string  提交用户id的表单元素的name。(默认是multi_friend_selector_name[])
      def xn_multi_friend_selector(options={})
        tag "xn:multi-friend-selector",options
      end



      # equired   Name    Type    Description
      # optional  color   string  显示字体的颜色。(默认是#000)
      # size  int   显示字体的大小。(默认是12)
      # bgcolor   string  背景颜色。(默认是#FFF)
      def xn_invite_box(options={})
        tag "xn:invite-box",options
      end

      # Required    Name    Type    Description
      # google_ad_client  string  Google Adsense账号
      # google_ad_slot  string  Google Adsense 生成的广告标识
      # google_ad_width   string  广告展示宽度
      # google_ad_height  string  广告展示高度
      # optional  google_alternate_color  string  
      # optional  google_ad_format  string  
      # optional  google_ad_type  string  
      # optional  google_ad_channel   string  
      # optional  google_color_border   string  
      # optional  google_color_bg   string  
      # optional  google_color_link   string  
      # optional  google_color_url  string  
      # optional  google_color_text   string
      def xn_adsense(google_ad_client,google_ad_slot,google_ad_width,google_ad_height,options={})
        options[:google_ad_client] = google_ad_client
        options[:google_ad_slot]   = google_ad_slot
        options[:google_ad_width]  = google_ad_width
        options[:google_ad_height] = google_ad_height
        tag "xn:adsense",options
      end

      # 描述
      # 将用户浏览器重定向到另一个页面。此标签只能在canvas上使用，且只能重定向到apps.51.com域名下的一个URL地址。 [注] facebook是可以重定向非apps.facebook.com域名下的URL地址
      # 属性
      # Required  Name  Type  Description
      # required  url   string  要跳转到的URL
      def xn_redirect(url)
        tag "xn:redirect",:url=>url
      end

      # 描述
      # 显示再用户时区的日期和时间.
      # 属性
      # Required  Name  Type  Description
      # required  t   int   时间戳
      # optional  tz  string  显示PHP支持的时区，+/-格式 例如:Etc/GMT-7.注意由于一个 bug，当用Etc/GMT格式的时间会与时区有关(默认值是登陆用户的时区)
      # preposition   bool  指出是否自动插入(默认是false) Indicates whether to automatically insert prepositions as appropriate into the time, where "at" prepends the time and "on" prepends the date if it appears. (Default value is false.)
      def xn_time(t,options={})
        options[:t] = t
        tag("xn:time",options)
      end

      # 描述
      # 设置canvas page的title，如果title不使用此标签进行设置，则默认为此app在菜单栏上显示的名称。 
      def xn_title(text,options={})
        options[:text]=text
        tag("xn:title",options)
      end

      # <% xn_submit do %>
      # <%= image_tag "submit.gif" %>
      # <% end %>
      def xn_submit(&block)
        content = capture(&block)
        concat(content_tag("xn:submit",content),block.binding)
      end


      # Required    Name    Type    Description
      # required  uid   string  需要获得用户名的51帐号
      # optional  usehim  bool  是否用第三人称：给“他/她”留言。(默认是false)
      # color   string  显示字体的颜色。(默认是#000)
      # size  int   显示字体的大小。(默认是12)
      # bgcolor   string  背景颜色。(默认是#FFF)
      # see http://developers.51.com/wiki/index.php?title=xn:message-sender for detail
      def xn_message_sender(uid,options={})
        options[:uid] = uid
        tag("xn:message-sender",options)
      end

        
    end
  end
end
module ActionView::Helpers::FormTagHelper

  private
  def html_options_for_form(url_for_options, options, *parameters_for_url)
    returning options.stringify_keys do |html_options|
      html_options["enctype"] = "multipart/form-data" if html_options.delete("multipart")
      html_options["action"] = url_for(url_for_options, *parameters_for_url)
      #         html_options.delete("id")
      html_options.delete("style")
      html_options.delete("class")
    end

  end

end
module ActionView::Helpers::UrlHelper
  private
  def convert_options_to_javascript!(html_options, url = '')
    confirm, popup = html_options.delete("confirm"), html_options.delete("popup")

    method, href = html_options.delete("method"), html_options['href']
    html_options['id']="link_to_#{html_options['method']}_#{rand(1000)}" if html_options['id'].blank?
    html_options["onclick"] = case
    when popup && method
      raise ActionView::ActionViewError, "You can't use :popup and :method in the same link"
    when confirm && popup
      "if (#{confirm_javascript_function(confirm,url)}) { #{popup_javascript_function(popup)} };return false;"
    when confirm && method
      "function confirm_callback(confirm){if(confirm){#{method_javascript_function(method,html_options['id'])}}};new Dialog(Dialog.DIALOG_CONFIRM,'#{escape_javascript(confirm)}','#{escape_javascript('确认')}',confirm_callback);return false;"
    when confirm
      "#{confirm_javascript_function(confirm,url)}"
    when method
      "#{method_javascript_function(method, html_options['id'],url, href)}return false;"
    when popup
      popup_javascript_function(popup) + 'return false;'
    else
      html_options["onclick"]
    end
  end
    
  def confirm_javascript_function(confirm,url='')
    "function confirm_callback(confirm){if(confirm)document.setLocation('#{url}');};new Dialog(Dialog.DIALOG_CONFIRM,'#{escape_javascript(confirm)}',\'#{escape_javascript('确认')}\',confirm_callback);return false"
  end
   
  def xn_form_javascript_function
    fields = %w{xn_sig_in_iframe xn_sig_time xn_sig_added xn_sig_user xn_sig_session_key xn_sig_expires xn_sig_api_key xn_sig_app_id}
    fields.map{ |key| "var s#{key}=document.createElement('input');s#{key}.setType('hidden');s#{key}.setName('#{key}');s#{key}.setValue('#{params[key]}');f.appendChild(s#{key});" }.join
    #    hidden_field_tag(key,params[key])}.join
  end


  def method_javascript_function(method,id=nil, url = '', href = nil)
    raise ActionView::ActionViewError, "Require id of a" if id.blank?
    action = (href && url.size > 0) ? "'#{url}'" : 'th.getHref()'
    submit_function =
      "var f = document.createElement('form'); f.setStyle({'display':'none'});" +
      "var th=document.getElementById('#{id}');th.getParentNode().appendChild(f); f.setMethod('POST'); f.setAction(#{action});"

    unless method == :post
      submit_function << "var m = document.createElement('input'); m.setType('hidden'); "
      submit_function << "m.setName('_method'); m.setValue('#{method}'); f.appendChild(m);"
    end
    submit_function << xn_form_javascript_function

    if protect_against_forgery?
      submit_function << "var s = document.createElement('input'); s.setType('hidden'); "
      submit_function << "s.setName('#{request_forgery_protection_token}'); s.setValue('#{escape_javascript form_authenticity_token}'); f.appendChild(s);"
    end
    submit_function << "f.submit();"
  end
end

#module ActionView::Helpers::PrototypeHelper
#  def remote_function(options)
#    function = ''
#    function<<"options[:before];" if options[:before]
#    function<<"var ajax = new Ajax(Ajax.XNML);"
#    if options[:update] && options[:update].is_a?(Hash)
#      function<<"success=document.getElementById('#{options[:update][:success]}');" if options[:update][:success]
#      if options[:update][:failure]
#        function<<"failure=document.getElementById('#{options[:update][:failure]}');"
#        function<<"ajax.onerror = function(errobj) {failure.setInnerXNML('!!!<ERROR> error code: ' + errobj.error + '; error description: ' + errobj.error_message);}"
#      end
#    elsif options[:update]
#      function<<"success=document.getElementById('#{options[:update]}');"
#    end
#    function<<"ajax.ondone = function(data) {success.setInnerXNML(data);}"
#    function<<"var params={"
#    if options[:method]
#      if options[:method]==:PUT
#        function<<"_method:'put'"
#      elsif options[:method]==:DELETE
#        function<<"_method:'delete'"
#      end
#    end
#    function<<"}"
#    function << "url='#{Xiaonei.localhost}#{escape_javascript(options[:url])}'"
#    function<<"ajax.post(url, params)"
#    if options[:confirm]
#      function="new Dialog(Dialog.DIALOG_CONFIRM, '#{options[:confirm]}','确认',new function(confirm){#{function}});"
#    end
#    function
#  end
#end

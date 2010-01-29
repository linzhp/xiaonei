module Xiaonei
  class User < Model
    def self.elm_name
      "user"
    end
    
    def self.attr_names
      [ :uid,
        :name,
        :sex,
        :birthday,
        :tinyurl,
        :headurl,
        :mainurl,
        :hometown_location,
        :country,
        :province,
        :city,
        :work_history,
        :work_info,
        :company_name,
        :description,
        :start_date,
        :end_date,
        :university_history,
        :university_info,
        :name,
        :year,
        :department,
        :hs_history,
        :hs_info,
        :name,
        :grad_year,
        :contact_info,
        :msn,
        :mobile_tel,
        :telephone,
        :web_site,
        :books,
        :movies,
        :music,
        :star,
        :zidou
      ]
    end
    
    for a in attr_names
      attr_accessor a
    end
    
    def self.find(uid)
      fields_str =  ([Xiaonei.sync_options['columns']].compact.flatten.collect {|c| c.class == Hash ? c.values.first : c}).join(",")
      case uid
      when Array
        Session.current.invoke_method("xiaonei.users.getInfo",:uids=>uid.join(","),:fields=>fields_str)#User.attr_names.join(","))
      else
        user = Session.current.invoke_method("xiaonei.users.getInfo","uids"=>uid,"fields"=>fields_str)#User.attr_names.join(","))
#                RAILS_DEFAULT_LOGGER.debug "in Xiaonei::User:"
#                RAILS_DEFAULT_LOGGER.debug user.inspect
        user ? user.first : nil
      end
    end

    #只能取得当前用户安装了本应用的好友
    def self.friend_ids
      Session.current.invoke_method("xiaonei.friends.getAppUsers")
    end

    def self.all_friend_ids
      Session.current.invoke_method("xiaonei.friends.get")
    end
  end
end

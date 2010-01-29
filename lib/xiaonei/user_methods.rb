module Xiaonei
  module UserMethods
  
    def self.included(base)
      base.send(:include,InstanceMethods)
      base.send(:extend,ClassMethods)
    end
    module ClassMethods
      def for(uids)
          case uids
          when Array
            users = find_all_by_xn_id(uids)
            if users.size < uids.size
              # 有部分用户不存在，获取他们到本地数据库
              uids_not_exists = uids - users.collect(&:xn_id)
              users_not_exists = uids_not_exists.collect { |uid| self.init_user_from_xiaonei uid }
              (users + users_not_exists).compact
            else
              users
            end
          else
            user = find_by_xn_id(uids)
            if user
              user
            else
              init_user_from_xiaonei(uids)
            end
          end
        end
        def init_user_from_xiaonei(uid)
          user = find_or_initialize_by_xn_id(uid)
          # xiaonei_user =  Xiaonei::User.find(uid)
          # if xiaonei_user
          user.save!
          user
          # else
          #   nil
          # end
        end
      end
    end

    module InstanceMethods
      # force 为 true 的时候，强制执行同步操作
      # 否则会判断最近同步日期
      def attempt_sync(force=false)
        if force || last_sync_at.nil? || last_sync_at < Time.now - (Xiaonei.sync_options['interval'] || 12.hours)
          # 从配置文件中读取
          sync_attributes
          sync_friendships
          self.last_sync_at = Time.now
          save!
        end
      end

      # 更新用户属性
      # 在 config/xiaonei.yml 中指定的字段都会被处理
      # 比如
      # sync:
      #   columns:
      #     - sex
      #     - htown: local_htown
      #     - other
      def sync_attributes
        xiaonei_user = Xiaonei::User.find(xn_id)
        #        puts "in sync_attributes"
        #        p xiaonei_user
        return unless xiaonei_user
        sync_columns = [Xiaonei.sync_options['columns']].compact.flatten
        sync_columns.each do |column|
          local_column = remote_column = column
          case column
          when Hash
            local_column = column.keys.first
            remote_column = column.values.first
          end
          if remote_column=="uid"
            next
          elsif remote_column=="session_key"#同步session key
            write_attribute local_column, Session.current.session_key
          else
            xn_value = xiaonei_user.send(remote_column)
            write_attribute(local_column,xn_value) unless xn_value.nil?
          end
        end
      end

      def sync_attributes!
        sync_attributes
        save!
      end

      #只能对current_user调用这个方法
      def sync_friendships
        friends = ::User.find_all_by_xn_id(Xiaonei::User.friend_ids)
        new_friends =friends-self.friends
        new_friends.each do |f|
          self.friends << f
        end

        #删除无效的好友关系，并为防止校内接口出错而添加了验证条件
#        unless friends.length == 0
#          deleted_friends = self.friends-friends
#          if friends.length > 5
#            deleted_friends = deleted_friends[0,5]
#          end
#          deleted_friends.each do |f|
#            self.friends.delete(f)
#          end
#        end
       
      end

      def sync_friendships!
        sync_friendships
        save!
      end

    end
  end

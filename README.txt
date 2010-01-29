== DESCRIPTION:

This is a modified version of David Li's xiaonei at
http://xiaonei.rubyforge.org/
It is the client library for renren.com and kaixin.com API, the leading
social network in China.

== FEATURES/PROBLEMS:

* Making writing Xiaonei application as easy as writting web app

== INSTALLATION:

* Copy xiaonei.yml to config/ dir, modify the corresponding fields

== REQUIREMENTS:

* users table should have xn_id field
* User model should set up a "friends" many-to-many relation, which points to 
  another User model instance

== Basic Usage:

1. Add this to the application controller

class ApplicationController < ActionController::Base
  acts_as_xiaonei_controller
  helper_method :xiaonei_session
  helper_method :current_user

  def current_user
      if @current_user.nil?
        xiaonei_id = xiaonei_session.user
        @current_user = User.for(xiaonei_id)
      end
      return @current_user
  end

  before_filter :attempt_sync_current_user, :only=>[:index]
  before_filter :check_authenticity
  after_filter  :logger_output

  protected
  def attempt_sync_current_user
    if current_user and
        (current_user.last_sync_at.nil? or
          current_user.last_sync_at < Time.now - (Xiaonei.sync_options['interval'] || 24.hours))
        current_user.attempt_sync
    end
  end

  def check_authenticity
      xn_id = xiaonei_session.invoke_method("xiaonei.users.getLoggedInUser")
      if xn_id.to_i != current_user.xn_id
        redirect_to root_path
      end
  end

  def logger_output
    logger.debug(response.body)
  end
end

2. Read the code and fix the bugs :)

== LICENSE:

(The MIT License)

Copyright (c) 2010 Clive

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

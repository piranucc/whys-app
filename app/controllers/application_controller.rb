# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  # set page title, meta keywords, meta description
  def set_seo_meta(options = {})
    title = options[:title] || ""
    keywords = options[:keywords] || ""
    description = options[:description] || ""

    if title.length > 0
      @page_title = "#{title} &raquo; "
    end
    @meta_keywords = keywords
    @meta_description = description
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_user(options = {})
    format = options[:format] || :html
    format = format.to_s
    if format == "html"
      authenticate_user!
    elsif format == "json"
      if current_user.blank?
        render :json => { :success => false, :msg => "你还没有登陆。" }
        return false
      end
    elsif format == "text"
      # Ajax 调用的时候如果没有登陆，那直接返回 nologin，前段自动处理
      if current_user.blank?
        render :text => "_nologin_" 
        return false
      end
    elsif format == "js"
      if current_user.blank?
        render :text => "location.href = '/login';"
        return false
      end
    end
  end

  def require_user_json
    require_user(:format => :json)
  end

  def require_user_js
    require_user(:format => :js)
  end

  def require_user_text
    require_user(:format => :text)
  end

  
end
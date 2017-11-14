require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include ActionController::MimeResponds
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def generate_last_n_months (num)
    arr = []
    num.times do |i|
      arr << DateTime.now.months_ago(i)
    end
    return arr
  end

end

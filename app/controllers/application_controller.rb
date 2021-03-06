# frozen_string_literal: true

class ApplicationController < ActionController::Base

  private

  def not_authenticated
    redirect_to new_user_sessions_path, alert: '請先登入'
  end
end

# frozen_string_literal: true

module Authenticatable
  attr_reader :current_user

  private

  def authenticate_doorkeeper!(*scopes)
    doorkeeper_authorize!(*scopes)
    return unless doorkeeper_token.present?

    @current_user = User.find(doorkeeper_token[:resource_owner_id])
    Raven.user_context(id: @current_user.id)
  end

  def authenticate_user!
    @current_user = AccessToken.verify(request.headers['X-Access-Token'])
    render_error_by_key :access_token_invalid unless @current_user
    Raven.user_context(id: @current_user&.id)
  end

  def authenticate_user_or_doorkeeper!(*scopes)
    if request.headers['Authorization']
      authenticate_doorkeeper!(*scopes)
    else
      authenticate_user!
    end
  end
end

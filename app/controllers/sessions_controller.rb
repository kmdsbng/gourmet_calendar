class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    provider = auth[:provider]
    nickname = auth[:info][:nickname]

    unless acceptable_user?(provider, nickname)
      redirect_to root_path, notice: '許可されたユーザでないのでログインできません'
    end

    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_path, notice: 'ログインしました'
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private
  def acceptable_user?(provider, nickname)
    acceptables = Set.new([['twitter', 'kmdsbng'], ['twitter', 'minotami']])
    acceptables.include?([provider, nickname])
  end
end

class Api::V0::ChatsController < Api::ApiController
  before_action :validate_token

  def index
    chats = current_user.chats
    render json: chats
  end

  def show
    chat = Chat.find(params[:id])
    render json: chat
  end

  def create
    form = Form::Chat.new(@user.chats.build, params[:chat])
    if form.submit
      render json: form.object
    else
      render json: form.errors
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end

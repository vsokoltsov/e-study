# frozen_string_literal: true
class Api::V0::CommentsController < Api::ApiController
  before_action :validate_token
  before_action :define_object, only: [:create, :update]
  before_action :new_object, only: :create
  before_action :edit_object, only: :update

  def create
    form = Form::Comment.new(@new_object, params[:comment])
    if form.submit
      render json: { comment: form.object }
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  def update
    form = Form::Comment.new(@edit_object, params[:comment])
    if form.submit
      render json: { comment: form.object }
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    render json: { deleted: comment } if comment.destroy
  end

  private

  def define_object
    comment_params = params[:comment]
    if comment_params[:type].present? && comment_params[:id].present?
      @object = comment_params[:type].camelize
                                     .constantize
                                     .find(comment_params[:id])
    end
  end

  def edit_object
    @edit_object = @object&.comments&.find(params[:id])
  end

  def new_object
    @new_object = @object&.comments&.build(user_id: current_user.id)
  end
end

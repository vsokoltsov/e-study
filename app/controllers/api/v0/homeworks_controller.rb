# frozen_string_literal: true
class Api::V0::HomeworksController < Api::ApiController
  before_action :validate_token
  before_action :build_homework, only: :create
  before_action :find_homework, only: [:show, :update, :destroy]

  def create
    form = Form::Homework.new(@new_homework, params[:homework])
    if form.submit
      render json: { homework: form.object }
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @homework, serializer: HomeworkSerializer
  end

  def update
    form = Form::Homework.new(@homework, params[:homework])
    if form.submit
      render json: { homework: form.object }
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { deleted_homework: @homework } if @homework.destroy
  end

  private

  def build_homework
    @new_homework = Course.find(params[:course_id])
                          .lessons.find(params[:lesson_id])
                          .homeworks.build(user_id: current_user.id)
  end

  def find_homework
    @homework = current_user.homeworks.find(params[:id])
  end
end
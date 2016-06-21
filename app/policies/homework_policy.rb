# frozen_string_literal: true
class HomeworkPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end

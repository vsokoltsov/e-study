class Form::Authorization < Form::Base
  attribute :email
  attribute :password

  def sign_in
    ActiveRecord::Base.with_advisory_lock("Session") do
      ActiveRecord::Base.transaction do

      end
    end
  end
end

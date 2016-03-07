class Form::Session < Form::Base
  include PasswordValidation
  include EmailValidation
  include JsonWebToken

  attr_accessor :token
  attribute :email
  attribute :password

  def attributes=(attrs)
    super(attrs)
    @user = User.find_by(email: email)
  end

  def submit
    return unless valid?
    authorization!
  end

  private

  def authorization!
    if @user && @user.authenticate(password)
      @token = generate_token_for_user(@user)
    else
      errors.add(:email, 'There is no such user')
    end
  end
end

class Api::Auth::SessionsController < ActionController::Base
  protect_from_forgery with: :null_session
  # include ApplicationHelper

  def send_otp
    begin
      unless params[:phone_number].scan(/\D/).empty?
        raise StandardError.new "Please enter digit only in phone no"
      end
      user = User.find_by(phone_number: params[:phone_number])
      unless user.present?
        raise StandardError.new "Invalid User"
      end
      user.generate_otp
      # unless Rails.env.development?
      #   send_sms("Your OTP is #{user.otp} - BJP SARAL", params[:phone_number])
      # end
      response = SessionResponce.success('Otp Sent successfully', {identification_token: user.jti})

      render json: {json: response, status: response[:code]}, status: :ok
      # respond_to do |format|
      #   format.json { render json: response, status: response[:code] }
      # end
    rescue => e
      response = SessionResponce.error(e.message)
      respond_to do |format|
        format.json { render json: response, status: response[:code] }
      end
    end
  end

  # Verifying an otp and creating a log in session
  def submit_otp
    begin
      user = User.find_by(jti: params[:identification_token])
      if user.present? && user.validate_otp(params[:otp])
        handle_correct_login(user)
        data =  payload(user).merge!(get_user_details(user))
        response = SessionResponce.success('Login successfully', data)
        respond_to do |format|
          format.json { render json: response, status: response[:code] }
        end
      else
        response = SessionResponce.error('Invalid OTP')
        respond_to do |format|
          format.json { render json: response, status: response[:code] }
        end
      end
    rescue => e
      response = SessionResponce.error(e.message)
      respond_to do |format|
        format.json { render json: response, status: response[:code] }
      end
    end
  end

  def handle_correct_login(user)
    user.regenerate_jti_if_required
    user.update(otp_created_at: nil)
    user.update(otp: nil)
  end

  def payload(user)
    {
      auth_token: JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base),
      auth_status: true,
      id: user.id,
      name: user.name,
      phone_number: user.phone_number,
    }
  end


  def get_user_details(user)
    {
      id: user.id,
      name: user.name,
      phone_number: user.phone_number,
      # address: user.address,
    }
  end

end


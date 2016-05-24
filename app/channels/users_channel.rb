class UsersChannel < ApplicationCable::Channel  
  def subscribed
    @channel_stream = current_user
    stream_from @channel_stream
  end

  def create(params)
    user = User.new(email: params['email'], password: params['password'])
    response_data = {}

    if user.save
      response_data = {
        operation: 'create', 
        status: 'success', 
        data: user,
        message: 'User is registered successfully'
      }
    else
      response_data = {
        operation: 'create', 
        status: 'fail', 
        data: user.errors.messages,
        message: 'User is not registered'
      }
    end

    ActionCable.server.broadcast @channel_stream, response_data
  end

  def login(params)
    user = User.where(email: params['email'], password: params['password']).first
    response_data = {}

    if user
      token = SecureRandom.urlsafe_base64(nil, false)
      user.token = token
      user.save!

      response_data = {
        operation: 'login',
        status: 'success',
        data: user,
        message: 'User has logged in successfully'
      }
    else
      response_data = {
        operation: 'login',
        status: 'fail',
        data: {user: 'not found'},
        message: 'User not found'
      }
    end

    ActionCable.server.broadcast @channel_stream, response_data
  end
end  

class UsersChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'users'
  end

  def createUser(params)
    user = User.new(email: params['email'], password: params['password'])
    response_data = {}

    if user.save
      response_data = {
        operation: 'createUser', 
        status: 'success', 
        response: 'User is registered successfully'
      }
    else
      response_data = {
        operation: 'createUser', 
        status: 'failed', 
        response: user.errors.full_messages
      }
    end

    ActionCable.server.broadcast 'users', response_data
  end

  def loginUser(params)
    user = User.where(email: params['email'], password: params['password']).first
    response_data = {}

    if user
      token = SecureRandom.urlsafe_base64(nil, false)
      user.token = token
      user.save!

      response_data = {
        operation: 'loginUser',
        status: 'success',
        response: { token: token }
      }
    else
      response_data = {
        operation: 'loginUser',
        status: 'failed',
        response: 'User not found'
      }
    end

    ActionCable.server.broadcast 'users', response_data
  end
end  

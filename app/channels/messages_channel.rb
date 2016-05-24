class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    reject and return if current_user.is_a? String

    @channel_stream = "messages_#{current_user.id}"
    stream_from @channel_stream

    @db_cursor = Message.where(->(doc) { doc[:receivers].contains(current_user.id) }).all.raw.changes(include_initial: true)
    Thread.new do
      @db_cursor.each do |changes|
        response_data = {
          operation: 'list',
          status: 'success',
          data: changes,
          message: 'New messages created'
        }
        ActionCable.server.broadcast @channel_stream, response_data
      end
    end
  end

  def unsubscribed
    @db_cursor.close if @db_cursor
  end

  def create(data)
    response_data = {}
    message = message.new(user_id: current_user.id, 
                          room_id: data.room_id,
                          content: data.content,
                          receivers: receivers_in_room(data.room_id)
                         )

    if message.save
      response_data = {
        operation: 'create',
        status: 'success',
        data: message,
        message: 'Message is created successfully'
      }
    else
      response_data = {
        operation: 'create',
        status: 'fail',
        data: message.errors.messages,
        message: 'Message is not created'
      }
    end

    ActionCable.server.broadcast @channel_stream, response_data
  end

  private

  def receivers_in_room(room_id)
    Room.find(room_id).receivers
  end
end  

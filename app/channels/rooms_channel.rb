class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @channel_stream = "rooms_#{current_user.id}"
    stream_from @channel_stream

    @db_cursor = Room.where(->(doc) {doc[:receivers].contains(current_user.id)}).all.raw.changes(include_initial: true)
    Thread.new do
      @db_cursor.each do |changes|
        response_data = {
          operation: 'list',
          status: 'success',
          data: changes,
          message: 'New room created'
        }
        ActionCable.server.broadcast @channel_stream, data: changes
      end
    end
  end

  def unsubscribed
    @db_cursor.close
  end

  def create(data)
    response_data = {}
    room = Room.new(receivers: data.receivers)

    if room.save
      response_data = {
        operation: 'create',
        status: 'success',
        data: room,
        message: 'Room is created successfully'
      }
    else
      response_data = {
        operation: 'create',
        status: 'fail',
        data: room.errors.messages,
        message: 'Room is not created'
      }
    end

    ActionCable.server.broadcast @channel_stream, response_data
  end
end

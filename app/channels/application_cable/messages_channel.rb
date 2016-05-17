class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'messages'

    Message.all.raw.changes(include_initial: true).each do |changes|
      ActionCable.server.broadcast 'messages', message: changes
    end
  end
end  

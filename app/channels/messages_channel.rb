class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "messages_#{current_user.id}"

    @db_cursor = Message.where(->(doc) { doc[:users].contains(current_user.id) }).all.raw.changes(include_initial: true)
    Thread.new do
      @db_cursor.each do |changes|
        ActionCable.server.broadcast "messages_#{current_user.id}", message: changes
      end
    end
  end

  def unsubscribed
    @db_cursor.close
  end
end  

class RoomsChannel < ApplicationCable::Channel
  attr_accessor :db_cursor

  def subscribed
    stream_from "rooms_#{current_user.id}"

    @db_cursor = Room.where(->(doc) {doc[:users].contains(current_user.id)}).all.raw.changes(include_initial: true)
    Thread.new do
      @db_cursor.each do |changes|
        ActionCable.server.broadcast "rooms_#{current_user.id}", data: changes
      end
    end
  end

  def unsubscribed
    @db_cursor.close
  end
end

# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user
    end

    protected

    def find_verified_user
      User.where(token: cookies['token']).first || "public-#{SecureRandom.uuid}"
    end
  end
end

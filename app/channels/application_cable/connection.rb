module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :kahoot_game_id

    def connect
      self.current_user = find_verified_user
      self.kahoot_game_id = nil
    end

    private

    def find_verified_user
      if (user = env['warden'].user) #Warden es usado por Devise para manejar las sesiones de los usuarios
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end

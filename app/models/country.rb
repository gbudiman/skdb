class Country < ActiveRecord::Base
  has_many :ip_countries # NO!!! --> , dependent: :destroy
end

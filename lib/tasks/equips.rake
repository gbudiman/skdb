namespace :equips do
  desc "Rebuild equipment list"
  task rebuild: :environment do
    Equip.rebuild_database!
  end

end

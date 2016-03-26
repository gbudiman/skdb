namespace :templates do
  desc "Rebuild Team Templates from GitHub"
  task rebuild: :environment do
    TeamTemplate.rebuild_database!
  end
end

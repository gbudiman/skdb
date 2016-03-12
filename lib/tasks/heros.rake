namespace :heros do
  desc "Rebuild Hero database"
  task rebuild: :environment do
  	XlsxInterface.rebuild_database! remote: true
  end

end

<<<<<<< HEAD
if Rails.env.production?
  workers Integer(ENV['WEB_CONCURRENCY'] || 2)
  threads_count = Integer(ENV['MAX_THREADS'] || 5)
  threads threads_count, threads_count

  preload_app!

  rackup      DefaultRackup
  port        ENV['PORT']     || 3000
  environment ENV['RACK_ENV'] || 'development'

  on_worker_boot do
    # Worker specific setup for Rails 4.1+
    # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
    ActiveRecord::Base.establish_connection
  end
=======
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 4)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
>>>>>>> 511cbc9d4941dfdeae8f969132a30a842663a4e9
end
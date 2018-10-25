web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bundle exec sidekiq
release: rails db:migrate

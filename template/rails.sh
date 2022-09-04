#!/bin/sh

cd /home/app && \
RAILS_ENV=production bundle exec rake db:migrate && \
RAILS_ENV=production bundle exec sidekiq -d -L log/sidekiq.log -c 5 -q default -q mailers

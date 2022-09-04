FROM phusion/passenger-ruby25:1.0.0

# Set correct environment variables.
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Taipei
ENV DEBIAN_FRONTEND=noninteractive
ENV SECRET_KEY_BASE=abcdefghijklmnopqrstuvwxyz0123456789

RUN mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bak
RUN apt update && apt install -y ca-certificates
RUN mv /etc/apt/sources.list.d.bak /etc/apt/sources.list.d

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y tzdata imagemagick yarn shared-mime-info

# Config timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Nginx configuration
RUN rm /etc/nginx/sites-enabled/default
ADD docker/config/nginx.conf /etc/nginx/sites-enabled/webapp.conf
ADD docker/config/nginx.env.conf /etc/nginx/main.d/nginx.env.conf

# Run Bundle in a cache efficient way
COPY --chown=app:app Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

COPY --chown=app:app . /home/app/

WORKDIR /home/app

RUN rm -rf tmp log && mkdir -p tmp log
RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN chown -R app /home/app

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable the Redis service.
RUN rm -f /etc/service/redis/down

# Start Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

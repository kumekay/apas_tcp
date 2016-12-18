FROM ruby:alpine
MAINTAINER Sergei Silnov <po@kumekay.com>
RUN mkdir -p /var/app
WORKDIR /var/app

# ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
#     DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev" \
#     RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs"
#
# RUN \
#   apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES

# Copy Gemfile
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

ENV PORT 4040

ENTRYPOINT ["bundle", "exec"]
EXPOSE 4040
CMD ["ruby","server.rb"]

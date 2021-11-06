FROM ruby:2.6.8

WORKDIR usr/src

COPY Gemfile .

RUN gem install bundler:2.2.24
COPY . .
RUN bundle install


EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
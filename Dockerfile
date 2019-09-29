FROM ruby:2.2 as runner

WORKDIR /app

ENV BUNDLE_PATH=/app/vendor/bundle

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

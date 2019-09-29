FROM ruby:2.2 as runner

WORKDIR /app

ENV BUNDLE_PATH=/app/vendor/bundle

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

FROM runner as pof.pm

ENV BUNDLE_APP_CONFIG=/app/.bundle
ENV BUNDLE_PATH=/bundle/vendor
ENV RAILS_ENV=production
ENV RACK_ENV_ENV=production

RUN groupadd -g 1005 pof.pm && \
    useradd -r -u 1005 -g pof.pm -d /app pof.pm && \
    mkdir -p /app /bundle && \
    chown -R pof.pm:pof.pm /app /bundle

COPY --chown=pof.pm:pof.pm Gemfile* /app/

USER pof.pm

RUN bundle config deployment true
RUN bundle config without "development test"

RUN bundle install --jobs 20 --retry 5
RUN bundle clean --force

COPY --chown=pof.pm:pof.pm . /app/

RUN bundle exec rake assets:precompile

ENV WEB_CONCURRENCY=30
ENV RAILS_MAX_THREADS=5

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

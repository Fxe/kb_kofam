FROM kbase/sdkpython:3.8.10
LABEL maintainer=fliu@anl.gov
# -----------------------------------------
# In this section, you can install any system dependencies required
# to run your App.  For instance, you could place an apt-get update or
# install line here, a git checkout to download code, or run any other
# installation scripts.

# Install Ruby and GNU Parallel
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ruby-full \
      parallel \
      curl \
      wget

ADD ./hmmer.tar.gz /opt/
WORKDIR /opt/hmmer-3.4/
RUN ./configure
RUN make install

# clean up apt cache to keep the image small
RUN rm -rf /var/lib/apt/lists/*

# Verify Ruby is new enough (>= 2.4)
# (Gem::Version avoids issues like "2.10" vs float comparisons)
RUN ruby -e 'require "rubygems"; \
  min=Gem::Version.new("2.4"); \
  cur=Gem::Version.new(RUBY_VERSION); \
  abort("Ruby too old: #{RUBY_VERSION}") if cur < min' \
 && ruby --version \
 && parallel --version

RUN mkdir /app_dir

# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod -R a+rw /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]

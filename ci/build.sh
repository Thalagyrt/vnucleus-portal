#!/bin/bash

set -e

bundle install
bundle exec rake db:drop db:setup
#bundle exec rake parallel:create parallel:prepare
bundle exec xvfb-run rake ci:setup:rspec spec
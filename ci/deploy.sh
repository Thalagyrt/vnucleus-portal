#!/bin/bash

set -e

if [ -z "$DEPLOY_ENV" ]; then
  echo "DEPLOY_ENV is not set. Exiting"
  exit 1
fi

bundle install
bundle exec cap $DEPLOY_ENV deploy
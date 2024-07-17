# frozen_string_literal: true
# see https://github.com/kbrock/bundler-inject/tree/gem_path

# specify one or more ruby files in this directory to be injected into bundler
# you can use `gem` to add new gems, `override_gem` to change an existing gem
# or `ensure_gem` to make sure a gem is there w/o worrying about if it is an
# override or not

ensure_gem 'derivative-rodeo', '~> 0.5', '>= 0.5.3'
ensure_gem 'json-canonicalization', '~> 0.3.3'
# we must ref the sha instead of a branch name
# rubocop:disable Metrics/LineLength
ensure_gem 'iiif_print', git: 'https://github.com/scientist-softserv/iiif_print.git', ref: 'c6b566e6c4350468d95a7a8890a844b6928d0059'
# rubocop:enable Metrics/LineLength

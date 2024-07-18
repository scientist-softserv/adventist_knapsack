# frozen_string_literal: true
# see https://github.com/kbrock/bundler-inject/tree/gem_path

# specify one or more ruby files in this directory to be injected into bundler
# you can use `gem` to add new gems, `override_gem` to change an existing gem
# or `ensure_gem` to make sure a gem is there w/o worrying about if it is an
# override or not

ensure_gem 'derivative-rodeo', '~> 0.5', '>= 0.5.3'
ensure_gem 'json-canonicalization', '~> 0.3.3'

# TODO: this is temporary to avoid error until all models have been valkyrized
ensure_gem 'iiif_print', github: 'https://github.com/scientist-softserv/iiif_print', branch: 'temp-branch-for-adventist-knapsack'

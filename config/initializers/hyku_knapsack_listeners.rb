# frozen_string_literal: true

Hyrax.publisher.subscribe(Listeners::SlugsListener.new)
Hyrax.publisher.subscribe(Listeners::FileSetThumbnailListener.new)
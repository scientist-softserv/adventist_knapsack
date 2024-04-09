# frozen_string_literal: true

FactoryBot.modify do
  factory :file_set do
    transient do
      user { FactoryBot.create(:user) }
      content { nil }
    end

    after(:build) do |fs, evaluator|
      fs.apply_depositor_metadata evaluator.user
    end

    factory :file_with_work do
      after(:build) do |file, _evaluator|
        file.title = ['testfile']
      end
      after(:create) do |file, evaluator|
        Hydra::Works::UploadFileToFileSet.call(file, evaluator.content) if evaluator.content
        work = create(:generic_work, user: evaluator.user)
        work.members << file
        work.save!
      end
    end
  end
end

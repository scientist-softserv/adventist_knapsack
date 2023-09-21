# frozen_string_literal: true

# OVERRIDE work form class from Hyrax v2.9.1
require_dependency Hyrax::Engine.root.join('app', 'forms', 'hyrax', 'forms', 'work_form').to_s

Hyrax::Forms::WorkForm.class_eval do
  # OVERRIDE: remove creator (author) and keywords from required fields on the work form
  self.required_fields = %i[title rights_statement]
end

# frozen_string_literal: true

module AuthorityService
  # Object based

  class DepartmentsService < DogBiscuits::Terms::DepartmentsTerms
    include ::LocalAuthorityConcern
  end

  class EventsService < DogBiscuits::Terms::EventsTerms
    include ::LocalAuthorityConcern
  end

  class GroupsService < DogBiscuits::Terms::GroupsTerms
    include ::LocalAuthorityConcern
  end

  class PeopleService < DogBiscuits::Terms::PeopleTerms
    include ::LocalAuthorityConcern
  end

  class PlacesService < DogBiscuits::Terms::PlacesTerms
    include ::LocalAuthorityConcern
  end

  class OrganisationsService < DogBiscuits::Terms::OrganisationsTerms
    include ::LocalAuthorityConcern
  end

  class ProjectsService < DogBiscuits::Terms::ProjectsTerms
    include ::LocalAuthorityConcern
  end

  class ConceptsService < DogBiscuits::Terms::ConceptsTerms
    include ::LocalAuthorityConcern
  end

  # File based

  class ContentVersionsService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('content_versions')
    end
  end

  class LicensesService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('licenses')
    end
  end

  class PublicationStatusesService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('publication_statuses')
    end
  end

  class QualificationLevelsService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('qualification_levels')
    end
  end

  class QualificationNamesService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('qualification_names')
    end
  end

  class ResourceTypeGeneralsService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('resource_type_generals')
    end
  end

  class ResourceTypesService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('resource_types')
    end
  end

  class RightsStatementsService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('rights_statements')
    end
  end

  # Table based
  class TableBasedAuthorityService < DogBiscuits::TableBasedAuthorityExtended
  end
end

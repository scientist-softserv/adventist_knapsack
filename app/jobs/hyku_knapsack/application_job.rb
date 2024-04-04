# frozen_string_literal: true

module HykuKnapsack
  class ApplicationJob < ActiveJob::Base
    PRIORITY_QUEUE_NAME = :auxiliary
    PRIORITY_QUEUE_ADDITIONAL_PRIORITY = 110
  
    # limit to 5 attempts
    retry_on StandardError, wait: :exponentially_longer, attempts: 5 do |_job, _exception|
      # Log error, do nothing, etc.
    end
  
    queue_as Hyrax.config.ingest_queue_name
  
    queue_with_priority do
      # we used to do these via GoodJobs config, but that was swallowing this queue_with_priority method.
      # Note: Higher priority numbers run first in all versions of GoodJob v3.x and below.
      # GoodJob v4.x will change job priority to give smaller numbers higher priority (default: 0),
      # in accordance with Active Job's definition of priority.
      case self
      when  Bulkrax::ScheduleRelationshipsJob
        calculate_priority base: 50
      when  CreateDerivativesJob
        calculate_priority base: 40
      when  CharacterizeJob
        calculate_priority base: 30
      when  Hyrax::GrantEditToMembersJob, ImportUrlJob, IngestJob
        calculate_priority base: 10
      when  AttachFilesToWorkJob
        calculate_priority base: -1
      when  Bulkrax::ImportWorkJob
        calculate_priority base: -5
      when  Bulkrax::ImportFileSetJob
        calculate_priority base: -15
      when  IiifPrint::Jobs::ChildWorksFromPdfJob
        calculate_priority base: -17
      when  Bulkrax::CreateRelationshipsJob, Bulkrax::ImporterJob, IiifPrint::Jobs::CreateRelationshipsJob
        calculate_priority base: -20
      when  ContentDepositEventJob, ContentUpdateEventJob
        calculate_priority base: -50
      else
        calculate_priority base: 0
      end
    end
  
    private
  
      def redirect_priority_jobs
        return :ingest unless priority_tenants_array.include? tenant_name
        PRIORITY_QUEUE_NAME
      end
  
      def calculate_priority(base:)
        return base unless priority_tenants_array.include? tenant_name
        PRIORITY_QUEUE_ADDITIONAL_PRIORITY + base
      end
  
      def priority_tenants_array
        @priority_array ||= ENV.fetch('AUXILIARY_QUEUE_TENANTS', '').split(',')
      end
  
      def tenant_name
        return nil unless current_tenant
        Account.find_by(tenant: current_tenant)&.name
      end
  end
end

# TESTED
module FindWithSlug
    def find(*args)
      # rubocop:disable Rails/FindBy
      results = where(slug_tesim: args.first).first
      # rubocop:enable Rails/FindBy
      results = super(*args) if results.blank?

      results
    end
end

# TESTED
ActiveFedora::Base.singleton_class.send :prepend, FindWithSlug

ActiveFedora::Persistence.class_eval do
  def delete(opts = {})
    return self if new_record?

    @destroyed = true

    id = self.id ## cache so it's still available after delete
    solr_delete = self.to_param || self.id
    # Clear out the ETag
    @ldp_source = build_ldp_resource(id)
    begin
      @ldp_source.delete
    rescue Ldp::NotFound
      raise ObjectNotFoundError, "Unable to find #{id} in the repository"
    end

    ## OVERRIDE change delete to to_param instead of ID
    ActiveFedora::SolrService.delete(solr_delete) if ActiveFedora.enable_solr_updates?
    self.class.eradicate(id) if opts[:eradicate]
    freeze
  end
end

# TESTED
ActiveFedora::Relation.class_eval do
  # Override ActiveFedora 12.1 to support slug lookup
  def find_each(conditions = {}, opts = {})
    cast = opts.delete(:cast)
    search_in_batches(conditions, opts.merge(fl: "#{ActiveFedora.id_field},fedora_id_ssi")) do |group|
      group.each do |hit|
        begin
          from_fedora = load_from_fedora(hit['fedora_id_ssi'], cast) if hit['fedora_id_ssi'].present?
          from_fedora = load_from_fedora(hit[ActiveFedora.id_field], cast) if from_fedora.blank?
          yield(from_fedora)
        rescue Ldp::Gone
          ActiveFedora::Base.logger.error "Although #{hit[ActiveFedora.id_field]} was found in Solr, it doesn't seem to exist in Fedora. The index is out of synch."
        end
      end
    end
  end
end

ActiveFedora::Aggregation::BaseExtension.class_eval do
  private
  def ordered_by_ids
    if id.present?
      query = "{!join from=proxy_in_ssi to=fedora_id_ssi}ordered_targets_ssim:#{id} OR {!join from=proxy_in_ssi to=id}ordered_targets_ssim:#{id}"
      rows = ActiveFedora::SolrService::MAX_ROWS
      ActiveFedora::SolrService.query(query, rows: rows).map { |x| x["id"] }
    else
      []
    end
  end
end

# admin set file count
Hyrax::AdminSetService.class_eval do
  private
  def count_files(admin_sets)
    file_counts = Hash.new(0)
    admin_sets.each do |admin_set|
      query = "{!join from=file_set_ids_ssim to=fedora_id_ssi}isPartOf_ssim:#{admin_set.id} OR {!join from=file_set_ids_ssim to=id}isPartOf_ssim:#{admin_set.id}"
      file_results = ActiveFedora::SolrService.instance.conn.get(
        ActiveFedora::SolrService.select_path,
        params: { fq: [query, "has_model_ssim:FileSet"],
          rows: 0 }
      )
      file_counts[admin_set.id] = file_results['response']['numFound']
    end
    file_counts
  end
end

# get file set ids for member presenter
# TESTED
Hyrax::MemberPresenterFactory.class_eval do
  private
  def file_set_ids
    @file_set_ids ||= begin
                        ActiveFedora::SolrService.query("{!field f=has_model_ssim}FileSet",
                          rows: 10_000,
                          fl: ActiveFedora.id_field,
                          fq: "{!join from=ordered_targets_ssim to=id}id:\"#{@work.fedora_id}/list_source\" OR {!join from=ordered_targets_ssim to=id}id:\"#{id}/list_source\"")
                          .flat_map { |x| x.fetch(ActiveFedora.id_field, []) }
                      end
  end
end

# search filesets and works in one go
Hyrax::MemberWithFilesSearchBuilder.class_eval do
  def include_contained_files(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "{!join from=file_set_ids_ssim to=fedora_id_ssi}{!join from=child_object_ids_ssim to=id}id:#{collection_id} OR {!join from=file_set_ids_ssim to=id}{!join from=child_object_ids_ssim to=id}id:#{collection_id}"
  end

  # include filters into the query to only include the collection members
  def include_collection_ids(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "{!join from=#{from_field} to=fedora_id_ssi}id:#{collection_id} OR {!join from=#{from_field} to=id}id:#{collection_id}"
  end
end

# TESTED
Hyrax::SolrDocument::OrderedMembers.class_eval do
  private

  def query_for_ordered_ids(limit: 10_000,
    proxy_field: 'proxy_in_ssi',
    target_field: 'ordered_targets_ssim')
    query = []
    query << "#{proxy_field}:#{fedora_id}" if fedora_id
    query << "#{proxy_field}:#{id}" if id
    query = query.join(' OR ')
    ActiveFedora::SolrService
      .query(query, rows: limit, fl: target_field)
      .flat_map { |x| x.fetch(target_field, nil) }
      .compact
  end

end

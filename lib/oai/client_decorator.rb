# frozen_string_literal: true

# rubocop:disable Naming/VariableName
# rubocop:disable Naming/PredicateName
module OAI
  # The purpose of this module is to work around the OAI implementation of Adventist; namely
  # the fact that after we pass make a resumption request, we loose our metadata_prefix context.
  #
  # Typically, the resumption token represents the full context of the previous request.  However,
  # in the Adventist implementation it's operating a bit like a pagination page indicator.
  #
  # @see https://github.com/scientist-softserv/adventist-dl/issues/271
  module ClientDecorator
    # @note override
    def do_resumable(responseClass, verb, opts)
      # NOTE: We need to close the options because throughout the life-cycle, the opts is deleted
      #       and updated.  This allows us to preserve
      original_options = opts.clone
      responseClass.new(do_request(verb, opts)) do |response|
        # This block is the &resumption_token that we pass to the below
        # `OAI::ResponseDecorator#initialize` method call.
        responseClass.new(
          do_request(verb, original_options.merge(resumption_token: response.resumption_token))
        )
      end
    end

    # @note override
    def is_resumption?(opts)
      # The original method tested that the only key in the options was the resumption_token.  Which
      # if it wasn't would then raise an exception.
      return true if opts.keys.include?(:resumption_token)
      false
    end
  end

  # This module is responsible for determining the completeListSize that's part of the
  # `resumptionToken` XML node.  And implementation detail of Adventist is that the OAI XML page's
  # that have records will have a `resumptionToken` with a `completeListSize` attribute.  And when
  # we are on the "last page" of the list of records we will still encounter a `resumptionToken`
  # (that acts looks like it's an incrementing page number).
  #
  # When we request the URL for that `resumptionToken` we will get another `resumptionToken` but it
  # will not have a `completeListSize`.
  module ResponseDecorator
    attr_reader :complete_list_size
    # @note Override
    #
    # @param doc [Object] Some tree/parser representation of an XML string.
    # @yieldparam resumption_token [Proc] This is the block from the above
    #             {OIA::ClientDecorator#do_resumable}
    def initialize(doc, &resumption_token)
      # The resumptionToken XML node looks as follows; we need to get the completeListSize attribute.
      #
      #   <resumptionToken expirationDate="2023-02-23T15:48:00Z" completeListSize="153" cursor="25">
      #     adl:periodical|2
      #   </resumptionToken>
      #
      # The completeListSize does not exist on tokens that would be for records outside the list
      # size window.  For example, for token "adl:periodical|100" that would represent records in
      # the 2500-ish range.  Which, per the adventist implementation of OAI, that token's XML
      # attributes would not include a `completeListSize` attribute.  Hence we know we are outside
      # of the range.
      #
      # Without this test and the follow `#resumable?` method, we would end up requesting infinite
      # pages because the OAI implementation keeps returning resumption tokens.
      @complete_list_size = get_attribute(xpath_first(doc, './/resumptionToken'), "completeListSize").to_i
      super
    end
  end

  module Resumable
    module ResumptionWrapperDecorator
      # @note Override
      #
      # @see OAI::ResponseDecorator
      def resumable?
        return super unless @response.respond_to?(:complete_list_size)
        return false if @response.complete_list_size.nil?
        return false if @response.complete_list_size.zero?
        super
      end
    end
  end
end
# rubocop:enable Naming/VariableName
# rubocop:enable Naming/PredicateName

OAI::Client.prepend(OAI::ClientDecorator)
OAI::Response.prepend(OAI::ResponseDecorator)
OAI::Resumable::ResumptionWrapper.prepend(OAI::Resumable::ResumptionWrapperDecorator)

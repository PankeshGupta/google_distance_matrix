module GoogleDistanceMatrix
  # Public: Thin wrapper class for an element in the matrix.
  #
  # The route has the data the element contains, pluss it references
  # it's origin and destination.
  #
  class Route
    STATUSES = %w[ok zero_results not_found].freeze

    ATTRIBUTES = %w[
      origin destination
      status
      distance_text distance_in_meters
      duration_text duration_in_seconds
      duration_in_traffic_text duration_in_traffic_in_seconds
    ].freeze

    attr_reader *ATTRIBUTES

    delegate *(STATUSES.map { |s| s + '?' }), to: :status, allow_nil: true


    def initialize(attributes = {})
      attributes = attributes.with_indifferent_access

      @origin = attributes[:origin]
      @destination = attributes[:destination]

      @status = ActiveSupport::StringInquirer.new attributes[:status].downcase

      if ok?
        @distance_text = attributes[:distance][:text]
        @distance_in_meters = attributes[:distance][:value]
        @duration_text = attributes[:duration][:text]
        @duration_in_seconds = attributes[:duration][:value]

        if attributes.key? :duration_in_traffic
          @duration_in_traffic_text = attributes[:duration_in_traffic][:text]
          @duration_in_traffic_in_seconds = attributes[:duration_in_traffic][:value]
        end
      end
    end



    def inspect
      inspection = ATTRIBUTES.reject { |a| public_send(a).blank? }.map { |a| "#{a}: #{public_send(a).inspect}" }.join ', '

      "#<#{self.class} #{inspection}>"
    end
  end
end

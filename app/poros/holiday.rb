class Holiday
  attr_reader :name,
              :date,
              :countryCode
  def initialize(data)
    @name = data[:name]
    @date = data[:date]
    @countryCode = data[:countryCode]

  end
end

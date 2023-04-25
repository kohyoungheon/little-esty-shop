require './app/services/nager_service'

class HolidaySearch

  def next_three_holidays
    holidays = service.get_holidays.first(3)
  end

  def service
    NagerService.new
  end
end
defmodule Wilt.Web.DateHelpers do
  @months %{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr",
            5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug",
            9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"}

  def format(%{day: day, month: month, year: year}) do
    "#{format_day(day)} #{format_month(month)} #{year}"
  end

  defp format_day(day) when day < 10, do: "0#{day}"
  defp format_day(day), do: "#{day}"
  
  defp format_month(month), do: @months[month]
end

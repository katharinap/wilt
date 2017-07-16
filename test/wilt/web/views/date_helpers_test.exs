defmodule Wilt.Web.DateHelpersTest do
  use Wilt.Web.ConnCase

  test "format returns a string for the given date" do
    date_str = Wilt.Web.DateHelpers.format(%{day: 1, month: 1, year: 2017})
    assert date_str == "01 Jan 2017"
    date_str = Wilt.Web.DateHelpers.format(%{day: 12, month: 12, year: 2017})
    assert date_str == "12 Dec 2017"
  end
  
end

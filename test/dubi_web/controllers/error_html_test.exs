defmodule DubiWeb.ErrorHTMLTest do
  use DubiWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template, only: [render_to_string: 4]

  test "renders 404.html" do
    html = render_to_string(DubiWeb.ErrorHTML, "404", "html", %{flash: %{}})
    assert html =~ "404"
    assert html =~ "Page not found"
  end

  test "renders 500.html" do
    assert render_to_string(DubiWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end

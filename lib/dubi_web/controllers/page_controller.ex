defmodule DubiWeb.PageController do
  use DubiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

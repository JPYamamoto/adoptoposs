defmodule AdoptopossWeb.AuthController do
  use AdoptopossWeb, :controller
  alias Adoptoposs.Accounts.UserFromAuth

  plug Ueberauth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    current_user = UserFromAuth.create(auth)

    conn
    |> put_flash(:info, "Successfully authenticated!")
    |> put_session(:current_user, current_user)
    |> configure_session(renew: true)
    |> redirect(to: "/", current_user: current_user)
  end

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: "/")
  end
end

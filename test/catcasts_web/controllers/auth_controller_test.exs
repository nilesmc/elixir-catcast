defmodule CatcastsWeb.AuthControllerTest do
  use CatcastsWeb.ConnCase
  import Catcasts.Factory

  alias Catcasts.Repo
  alias Catcasts.User

  @ueberauth_auth %{credentials: %{token: "this-is-a-token"},
                    info: %{email: "mom@example.com", first_name: "Mother", last_name: "Lady"}, provider: :google}

  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert redirected_to(conn, 302)
  end

  test "creates user from Google information", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end

  test "shows a sign in with Google link when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in with Google"
  end

  test "shows a sign out link when signed in", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/")

    assert html_response(conn, 200) =~ "Sign out"
  end

  test "signs out user", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/auth/signout")
    |> get("/")

    assert conn.assigns.user == nil
  end

end

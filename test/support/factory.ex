defmodule Catcasts.Factory do
  use ExMachina.Ecto, repo: Catcasts.Repo

  def user_factory do
    %Catcasts.User{
      token: "this-is-a-token",
      email: "mom@example.com",
      first_name: "Mother",
      last_name: "Lady",
      provider: "google"
    }
  end
end
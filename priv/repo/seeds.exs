# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Easypub.Repo.insert!(%Easypub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Easypub.Repo
alias Easypub.Accounts.User

attrs = %{
  email: "viniciusbfs2012@gmail.com",
  password: "Easypub123",
  name: "admin-easypub",
  phone: "1211111111",
  role: "admin"
}

%User{}
|> User.changeset(attrs)
|> Repo.insert!()

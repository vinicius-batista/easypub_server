defmodule EasypubWeb.Schema.AccountsTypes do
  @moduledoc """
  Graphql schema related to Accounts
  """
  use Absinthe.Schema.Notation
  alias EasypubWeb.Resolvers.AccountsResolvers
  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}

  @desc "User object"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
  end

  @desc "AuthTokens object"
  object :auth_tokens do
    field(:access_token, :string)
    field(:refresh_token, :string)
    field(:type, :string)
  end

  @desc "Input object for login"
  input_object :login_user_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "Input object for register"
  input_object :register_user_input do
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:phone, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "Accounts mutations"
  object :accounts_mutations do
    field :register_user, :auth_tokens do
      arg(:input, non_null(:register_user_input))
      resolve(&AccountsResolvers.register_user/3)
      middleware(HandleErrors)
    end

    field :login_user, :auth_tokens do
      arg(:input, non_null(:login_user_input))
      resolve(&AccountsResolvers.login_user/3)
      middleware(HandleErrors)
    end

    field :logout, :string do
      arg(:refresh_token, non_null(:string))
      middleware(Authentication)
      resolve(&AccountsResolvers.logout/3)
      middleware(HandleErrors)
    end
  end

  @desc "Accounts queries"
  object :accounts_queries do
    field :new_access_token, :auth_tokens do
      arg(:refresh_token, non_null(:string))
      resolve(&AccountsResolvers.new_access_token/3)
      middleware(HandleErrors)
    end

    field :profile, :user do
      middleware(Authentication)
      resolve(&AccountsResolvers.profile/3)
    end
  end
end

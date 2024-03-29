defmodule EasypubWeb.Schema.AccountsTypes do
  @moduledoc """
  Graphql schema related to Accounts
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias EasypubWeb.Resolvers.AccountsResolvers
  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}
  alias Easypub.Bars.Bar

  @desc "User object"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:bar, :bar, resolve: dataloader(Bar))
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

  input_object :register_bar_owner_input do
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:phone, non_null(:string))
    field(:password, non_null(:string))
    field(:bar_address, non_null(:string))
    field(:bar_name, non_null(:string))
    field(:bar_avatar, non_null(:string))
  end

  @desc "Input object for update_profile"
  input_object :update_profile_input do
    field(:email, :string)
    field(:name, :string)
    field(:phone, :string)
  end

  @desc "Input object for change_password"
  input_object :change_password_input do
    field(:current_password, non_null(:string))
    field(:new_password, non_null(:string))
  end

  @desc "Accounts mutations"
  object :accounts_mutations do
    field :register_user, :auth_tokens do
      arg(:input, non_null(:register_user_input))
      resolve(&AccountsResolvers.register_user/3)
      middleware(HandleErrors)
    end

    field :register_bar_owner, :auth_tokens do
      arg(:input, non_null(:register_bar_owner_input))
      resolve(&AccountsResolvers.register_bar_owner/3)
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

    field :update_profile, :user do
      arg(:input, non_null(:update_profile_input))
      middleware(Authentication)
      resolve(&AccountsResolvers.update_profile/3)
      middleware(HandleErrors)
    end

    field :change_password, :user do
      arg(:input, non_null(:change_password_input))
      middleware(Authentication)
      resolve(&AccountsResolvers.change_password/3)
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

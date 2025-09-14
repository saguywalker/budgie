defmodule Budgie.TrackingTest do
  use Budgie.DataCase

  import Budgie.TrackingFixtures

  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = valid_budget_attributes(%{creator_id: user.id})

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
      assert budget.start_date == ~D[2023-01-01]
      assert budget.end_date == ~D[2023-01-31]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 requires name" do
      attrs_without_name = valid_budget_attributes() |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs_without_name)

      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      attrs_with_invalid_dates =
        valid_budget_attributes()
        |> Map.merge(%{start_date: ~D[2023-01-31], end_date: ~D[2023-01-01]})

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs_with_invalid_dates)

      assert changeset.valid? == false
      assert %{end_date: ["must be after start date"]} = errors_on(changeset)
    end
  end
end

defmodule Prototype.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:video) do
      add :videos, :string

      timestamps(type: :utc_datetime)
    end
  end
end

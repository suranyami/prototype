defmodule Prototype.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "video" do
    field :videos, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:videos])
    |> validate_required([:videos])
  end
end

defmodule Prototype.VideosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Prototype.Videos` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        videos: "some videos"
      })
      |> Prototype.Videos.create_video()

    video
  end
end

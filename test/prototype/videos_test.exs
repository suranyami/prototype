defmodule Prototype.VideosTest do
  use Prototype.DataCase

  alias Prototype.Videos

  describe "video" do
    alias Prototype.Videos.Video

    import Prototype.VideosFixtures

    @invalid_attrs %{videos: nil}

    test "list_video/0 returns all video" do
      video = video_fixture()
      assert Videos.list_video() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Videos.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      valid_attrs = %{videos: "some videos"}

      assert {:ok, %Video{} = video} = Videos.create_video(valid_attrs)
      assert video.videos == "some videos"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Videos.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      update_attrs = %{videos: "some updated videos"}

      assert {:ok, %Video{} = video} = Videos.update_video(video, update_attrs)
      assert video.videos == "some updated videos"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Videos.update_video(video, @invalid_attrs)
      assert video == Videos.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Videos.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Videos.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Videos.change_video(video)
    end
  end
end

defmodule PrototypeWeb.VideoLiveTest do
  use PrototypeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Prototype.VideosFixtures

  @create_attrs %{videos: "some videos"}
  @update_attrs %{videos: "some updated videos"}
  @invalid_attrs %{videos: nil}

  defp create_video(_) do
    video = video_fixture()
    %{video: video}
  end

  describe "Index" do
    setup [:create_video]

    test "lists all video", %{conn: conn, video: video} do
      {:ok, _index_live, html} = live(conn, ~p"/video")

      assert html =~ "Listing Video"
      assert html =~ video.videos
    end

    test "saves new video", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/video")

      assert index_live |> element("a", "New Video") |> render_click() =~
               "New Video"

      assert_patch(index_live, ~p"/video/new")

      assert index_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#video-form", video: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/video")

      html = render(index_live)
      assert html =~ "Video created successfully"
      assert html =~ "some videos"
    end

    test "updates video in listing", %{conn: conn, video: video} do
      {:ok, index_live, _html} = live(conn, ~p"/video")

      assert index_live |> element("#video-#{video.id} a", "Edit") |> render_click() =~
               "Edit Video"

      assert_patch(index_live, ~p"/video/#{video}/edit")

      assert index_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#video-form", video: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/video")

      html = render(index_live)
      assert html =~ "Video updated successfully"
      assert html =~ "some updated videos"
    end

    test "deletes video in listing", %{conn: conn, video: video} do
      {:ok, index_live, _html} = live(conn, ~p"/video")

      assert index_live |> element("#video-#{video.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#video-#{video.id}")
    end
  end

  describe "Show" do
    setup [:create_video]

    test "displays video", %{conn: conn, video: video} do
      {:ok, _show_live, html} = live(conn, ~p"/video/#{video}")

      assert html =~ "Show Video"
      assert html =~ video.videos
    end

    test "updates video within modal", %{conn: conn, video: video} do
      {:ok, show_live, _html} = live(conn, ~p"/video/#{video}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Video"

      assert_patch(show_live, ~p"/video/#{video}/show/edit")

      assert show_live
             |> form("#video-form", video: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#video-form", video: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/video/#{video}")

      html = render(show_live)
      assert html =~ "Video updated successfully"
      assert html =~ "some updated videos"
    end
  end
end

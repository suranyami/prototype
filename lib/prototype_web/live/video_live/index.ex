defmodule PrototypeWeb.VideoLive.Index do
  use PrototypeWeb, :live_view

  alias Prototype.Videos
  alias Prototype.Videos.Video

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :video_collection, Videos.list_video())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Video")
    |> assign(:video, Videos.get_video!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Video")
    |> assign(:video, %Video{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Video")
    |> assign(:video, nil)
  end

  @impl true
  def handle_info({PrototypeWeb.VideoLive.FormComponent, {:saved, video}}, socket) do
    {:noreply, stream_insert(socket, :video_collection, video)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    video = Videos.get_video!(id)
    {:ok, _} = Videos.delete_video(video)

    {:noreply, stream_delete(socket, :video_collection, video)}
  end
end

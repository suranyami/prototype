defmodule PrototypeWeb.Router do
  use PrototypeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PrototypeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PrototypeWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/video", VideoLive.Index, :index
    live "/video/new", VideoLive.Index, :new
    live "/video/:id/edit", VideoLive.Index, :edit
    live "/video/:id", VideoLive.Show, :show
    live "/video/:id/show/edit", VideoLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PrototypeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:prototype, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PrototypeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

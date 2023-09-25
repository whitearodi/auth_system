defmodule AuthSystemWeb.Router do

  use AuthSystemWeb, :router

  import AuthSystemWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuthSystemWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_users
  end

  pipeline :layouts do
    plug(:put_root_layout, html: {AuthSystemWeb.Layouts, :sidebar})
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthSystemWeb do
    pipe_through [:browser, :layouts, :require_authenticated_users]

    get "/", PageController, :home

    # get "/payments", PaymentController, :index
    # get "/payments/new", PaymentController, :new
    # post "/payments/new", PaymentController, :create
    # get "/payments/:id/edit", PaymentController, :edit
    # get "/payments/:id/show", PaymentController, :show
    # delete "/payments/:id/delete", PaymentController, :delete

    resources "/payments", PaymentController


    resources "/inventorys", InventoryController

    resources "/sales", SaleController

    # resources "/users", UserController


    get "/users/log_out", UserSessionController, :log_out
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthSystemWeb do
  #   pipe_through :api
  # end

  scope "/", AuthSystemWeb do
    pipe_through [:browser, :redirect_if_users_authenticated]

    live_session :redirect_if_users_authenticated do
      # on_mount: [{AuthSystemWeb.UserAuth, :redirect_if_users_authenticated}] do
      live "/users/register", RegistrationLive.Index, :new
      live "/users/log_in", LoginLive.Index, :new
      live "/users/reset_password", ResetPasswordLive.Index, :new
    end
    post "/users/set-session", UserSessionController, :create


    post "/users/log_in", UserSessionController, :create
  end

  # scope "/", AuthSystemWeb do
  #   pipe_through [:browser]

  #   get "/payments", PaymentController, :index
  #   post "/payments/new", PaymentController, :create
  #   delete "/payments/:id", PaymentController, :delete
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:auth_system, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuthSystemWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

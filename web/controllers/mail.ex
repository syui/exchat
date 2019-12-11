defmodule Exchat.MailController do
  use Exchat.Web, :controller

  alias Exchat.Mailer

  def index(conn, _params) do
    Exchat.Email.hello_email("syui@syui.cf") 
      |> Mailer.deliver_now
    render conn, "index.html"
  end
end

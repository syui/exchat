defmodule Exchat.Email do
  use Bamboo.Phoenix, view: Exchat.EmailView

  def hello_email(email) do

    new_email
    |> to(System.get_env("MAIL"))
    |> from(System.get_env("MAILGUN_FROM"))
    |> subject("user login")
    |> text_body(email)
  end
end

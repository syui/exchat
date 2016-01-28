defmodule Exchat.ApiAuth do
  import Plug.Conn

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Joken, only: [token: 1, with_exp: 2, with_signer: 2, sign: 1,
                       get_compact: 1, verify: 1, hs256: 1, get_claims: 1]

  alias Exchat.User

  @default_jwt_secret Application.get_env(:exchat, User)[:jwt_secret]
  @default_expires_in 7 * 24 * 60 * 60 # 7 day

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_user_id(conn)
    user = user_id && repo.get_by!(User, id: user_id)
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{message: "Can't be authorized!"})
      |> halt
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> assign(:auth_token, generate_token(user))
  end

  def login_by_email_pass(conn, email, pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && checkpw(pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def generate_token(user, expires \\ :os.system_time(:seconds) + @default_expires_in, jwt_secret \\ @default_jwt_secret)
      when is_binary(jwt_secret) and is_integer(expires) do
    %{user_id: user.id}
    |> token
    |> with_exp(expires)
    |> with_signer(hs256(jwt_secret))
    |> sign
    |> get_compact
  end

  def parse_token(token, jwt_secret \\ @default_jwt_secret)
  def parse_token("Bearer " <> token, jwt_secret) do
    parse_token(token, jwt_secret)
  end
  def parse_token(token, jwt_secret) do
    token
    |> token
    |> with_signer(hs256(jwt_secret))
  end

  defp get_user_id(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [token] -> get_user_id_from_token(token)
      _       -> nil
    end
  end

  defp get_user_id_from_token(token) do
    case token
          |> parse_token
          |> verify
          |> get_claims
          |> Map.fetch("user_id") do
      {:ok, user_id} -> user_id
      _              -> nil
    end
  end

end
defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_server do
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: 5454)
  end

  post "/add_entry" do
    conn
    |> Plug.Conn.fetch_params
    |> add_entry
    |> respond
  end

  get "/entries" do
    conn
    |> Plug.Conn.fetch_params
    |> entries
    |> respond
  end

  defp add_entry(conn) do
    IO.puts "date: #{conn.params["date"]}"
    conn.params["list"]
    |> Todo.Cache.server_process
    |> Todo.Server.add_entry(
    %{
      date: parse_date(conn.params["date"]),
      title: conn.params["title"],
    }
    )

    Plug.Conn.assign(conn, :response, "OK")
  end

  defp entries(conn) do
    response = conn.params["list"]
    |> Todo.Cache.server_process
    |> Todo.Server.entries(parse_date(conn.params["date"]))
    |> format_entries

    Plug.Conn.assign(conn, :response, response)
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end

  defp parse_date(str) do
    # parse a date str from "20131219" to {2013, 12, 19}
    {
      String.slice(str, 0, 4) |> String.to_integer,
      String.slice(str, 4, 2) |> String.to_integer,
      String.slice(str, 6, 2) |> String.to_integer,
    }
  end

  defp format_entries(entries) do
    # format a list of maps to a plain string
    entries
    |> Enum.map(fn %{date: {year, month, day}, title: title} ->
      "#{year}-#{month}-#{day}  #{title}"
    end)
    |> Enum.join("\n")
  end
end

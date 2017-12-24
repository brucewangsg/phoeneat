defmodule PhoeneatWeb.LinkController do
  use PhoeneatWeb, :controller
  import Ecto.Query, warn: false

  alias Phoeneat.Repo
  alias Phoeneat.Link
  require Logger

  def redirection(conn, params) do
    query = from link in Link,
            where: link.shortcode == ^(params["id"]), 
            limit: 1
    records = Repo.all(query)

    if length(records) == 0 do
      redirect conn, to: "/notfound"
    else
      record = Enum.at(records, 0)
      redirect conn, external: "#{record.protocol}://#{String.replace(record.original_url, ~r/^https?:\/\//,  "")}"
    end
  end

  def submit(conn, params) do
    url = String.replace(params["url"], ~r/#.*$/, "")
    uri = URI.parse(url)

    if uri.host && uri.path && uri.scheme do
      query = from link in Link,
              where: link.domain == ^(uri.host) and link.original_url == ^(String.replace(url, ~r/^https?:\/\//,  "")), 
              limit: 1
      records = Repo.all(query)

      if length(records) == 0 do
        { :ok, record } = %Link{} |> Link.changeset(%{ domain: uri.host, original_url: String.replace(url, ~r/^https?:\/\//,  ""), shortcode: Link.insert_shortcode, protocol: uri.scheme }) |> Repo.insert()

        json conn, %{
          shortcode: "https://#{conn.host}#{":#{conn.port}" |> String.replace(~r/^:$/,  "")}/#{record.shortcode}"
        }        
      else
        record = Enum.at(records, 0)
        json conn, %{
          shortcode: "https://#{conn.host}#{":#{conn.port}" |> String.replace(~r/^:$/,  "")}/#{record.shortcode}"
        }
      end
    else
      json conn, %{
        error: "Bad URI"
      }      
    end

  end
end


# curl 'http://localhost:4000/api/transform' --data 'url=https%3A%2F%2Fgoogle.com%2F' --compressed
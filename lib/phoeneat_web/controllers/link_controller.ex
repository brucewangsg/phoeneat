defmodule PhoeneatWeb.LinkController do
  use PhoeneatWeb, :controller
  import Ecto.Query, warn: false
  import HTTPotion

  alias Phoeneat.Repo
  alias Phoeneat.Link
  alias Phoeneat.Visitor
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

      %Visitor{} |> Visitor.changeset(%{ ip_address: to_string(:inet_parse.ntoa(conn.remote_ip)), user_agent: Enum.at(get_req_header(conn, "user-agent"), 0), link_id: record.id }) |> Repo.insert()
    end
  end

  def info(conn, params) do
    query = from link in Link,
            where: link.shortcode == ^(params["id"]), 
            limit: 1
    records = Repo.all(query)

    if length(records) == 0 do
      json conn, %{ info: "No data" }
    else
      link = Enum.at(records, 0)

      query = from visitor in Visitor,
              where: visitor.link_id == ^(link.id), 
              limit: 100
      visitors = Repo.all(query)

      json conn, %{ link: link.original_url, stats: Enum.map(visitors, fn visitor -> %{ ip_address: visitor.ip_address, user_agent: visitor.user_agent, visit_time: visitor.inserted_at } end) }
    end
  end

  def submit(conn, params) do
    url = String.replace(params["url"], ~r/#.*$/, "")
    uri = URI.parse(url)

    has_responded = false
    if uri.host && uri.path && uri.scheme do
      query = from link in Link,
              where: link.domain == ^(uri.host) and link.original_url == ^(String.replace(url, ~r/^https?:\/\//,  "")), 
              limit: 1
      records = Repo.all(query)

      if length(records) == 0 do
        response = HTTPotion.get url
        if response.__struct__ == HTTPotion.Response && (response.status_code == 200 || response.status_code == 302 || response.status_code == 301) do
          case %Link{} |> Link.changeset(%{ domain: uri.host, original_url: String.replace(url, ~r/^https?:\/\//,  ""), shortcode: Link.insert_shortcode, protocol: uri.scheme }) |> Repo.insert() do
            { :ok, record } -> 
              has_responded = true

              json conn, %{
                shortcode: "https://#{conn.host}#{":#{conn.port}" |> String.replace(~r/^:80$/,  "")}/#{record.shortcode}"
              }                    
          end
        else
          has_responded = true

          json conn, %{
            error: "Web page doesn't exist"
          }                       
        end
      else
        record = Enum.at(records, 0)
        has_responded = true

        json conn, %{
          shortcode: "https://#{conn.host}#{":#{conn.port}" |> String.replace(~r/^:80$/,  "")}/#{record.shortcode}"
        }
      end
    end

    if !has_responded do
      json conn, %{
        error: "Bad URI"
      }      
    end
  end

  def lookup(conn, params) do
    url = String.replace(params["url"], ~r/#.*$/, "")
    uri = URI.parse(url)

    if uri.host && uri.path && uri.scheme do
      query = from link in Link,
              where: link.domain == ^(uri.host) and link.original_url == ^(String.replace(url, ~r/^https?:\/\//,  "")), 
              limit: 1
      records = Repo.all(query)

      if length(records) == 0 do
        json conn, %{
          info: "Not Found"
        }        
      else
        record = Enum.at(records, 0)
        json conn, %{
          shortcode: "https://#{conn.host}#{":#{conn.port}" |> String.replace(~r/^:80$/,  "")}/#{record.shortcode}"
        }
      end
    else
      json conn, %{
        info: "Not Found"
      }        
    end

  end
end


# curl 'http://localhost:4000/api/transform' --data 'url=https%3A%2F%2Fgoogle.com%2F' --compressed
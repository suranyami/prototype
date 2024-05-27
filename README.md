# Prototype

This is a prototype for tying out such things as:

* Code smells and anti-patterns
* Refactoring patterns
* Experimenting
* Problem solving

## Using this repo

* Clone this repo
* Create a branch to explore any of the above
* Commit and push your changes
* Create a PR to merge your branch into master and add @suranyami as a reviewer

## Refactor examples

### You almost never need case statements

For instance, take this module:

```elixir
defmodule Pollen.MvPlatform.Client do
  @platform_graphql_url Application.compile_env(:pollen, [:platform_graphql_url])

  def request(query, data, jwt_token) do
    auth = {:bearer, jwt_token}
    req = Req.new(base_url: @platform_graphql_url, auth: auth)
    req = AbsintheClient.attach(req)
    graphql = {query, data}

    case Req.post(req, graphql: graphql, json: data) do
      {:ok, %{body: body, status: status}} when status == 200 ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
```

Firstly, most of the `request` function is not doing anything meaningful.

At the very least, this function should probably log when an error status is returned.

The following would be more intentional, idiomatic to elixir, and quickly able to be expanded to cope with other

```elixir
def request(query, data, jwt_token) do
  %{base_url: @platform_graphql_url, auth: {:bearer, jwt_token}}
  |> Req.new()
  |> AbsintheClient.attach(req)
  |> Req.post(graphql: {query, data}, json: data)
  |> respond()
end

def respond({:ok, %{body: body, status: 200}}), do: {:ok, body}

def respond({:ok, %{body: body, status: status}}) do
  Logger.error("Server responded with #{status} error: #{inspect(body)}")
  {:error, inspect(body)}
end

def respond({:error, error}) do
  Logger.error(error)
  {:error, error}
end
```
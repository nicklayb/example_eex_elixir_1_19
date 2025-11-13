defmodule SuperEngine do
  @behaviour EEx.Engine

  @impl EEx.Engine
  defdelegate handle_body(state), to: EEx.Engine

  @impl EEx.Engine
  defdelegate handle_begin(state), to: EEx.Engine

  @impl EEx.Engine
  defdelegate handle_end(state), to: EEx.Engine

  @impl EEx.Engine
  defdelegate handle_text(state, meta, text), to: EEx.Engine

  @impl EEx.Engine
  def init(opts) do
    modules = Keyword.fetch!(opts, :modules)
    aliases = Keyword.fetch!(opts, :alias_names)

    opts
    |> EEx.Engine.init()
    |> Map.put(:aliases, aliases)
    |> Map.put(:modules, modules)
  end

  @impl EEx.Engine
  def handle_expr(state, "", expr) do
    EEx.Engine.handle_expr(state, "=", expr)
  end
end

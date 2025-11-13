defmodule Test do
  def eval_string(string, bindings, modules, aliases) do
    EEx.eval_string(string, bindings, engine: SuperEngine, modules: modules, alias_names: aliases)
  end
end

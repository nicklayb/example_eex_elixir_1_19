# EEx Typespec issue example in Elixir 1.19

Here's a sample project to demonstrate the typespecing issue running Dialyzer with a custom EEx engine.

## The problem

Running Dialzyer for this example codebase leads to the following error:

```
lib/test.ex:2:7:no_return
Function eval_string/4 has no local return.
________________________________________________________________________________
lib/test.ex:3:9:call
The function call will not succeed.

EEx.eval_string(_string :: any(), _bindings :: any(), [
  {:alias_names, _} | {:engine, SuperEngine} | {:modules, _},
  ...
])

will never return since the 3rd arguments differ
from the success typing arguments:

(binary(), [{atom() | tuple(), _}], [
  {:file, binary()}
  | {:line, pos_integer()}
  | {:module, atom()}
  | {:prune_binding, boolean()}
])

________________________________________________________________________________
done (warnings were emitted)
Halting VM with exit status 2
```

Dialyzer here tells us that passing other options than `file`, `line`, `module` and `prune_binding` leads a function that never returns.

What is misleading is that this is the spec of `Code.eval_string/3` and not `EEx.eval_string/3`.

##### EEx.eval_string/3

[Permalink](https://github.com/elixir-lang/elixir/blob/b45853f0431a26258dbf2f0b9eb000d2c5b650fe/lib/eex/lib/eex.ex#L297)

```elixir
  @type tokenize_opt ::
          {:file, binary()}
          | {:line, line}
          | {:column, column}
          | {:indentation, non_neg_integer}
          | {:trim, boolean()}

  @type compile_opt ::
          tokenize_opt
          | {:engine, module()}
          | {:parser_options, Code.parser_opts()}
          | {atom(), term()} # <- Becuase of this, `alias_names` and `modules` should work.

  @spec eval_string(String.t(), keyword, [compile_opt]) :: term()
```

##### Code.eval_string/3

[Permalink](https://github.com/elixir-lang/elixir/blob/f248994830d584012dbce8576865340a7aa814a1/lib/elixir/lib/code.ex#L615)

```elixir
  @type env_eval_opts :: [
          file: binary(),
          line: pos_integer(),
          module: module(),
          prune_binding: boolean()
        ]
  @spec eval_string(List.Chars.t(), binding, Macro.Env.t() | env_eval_opts) :: {term, binding}
```



defmodule Devton.Test.InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Commanded.Assertions.EventAssertions

      import Devton.Test.AggregateUtils
    end
  end

  setup do
    on_exit(fn ->
      :ok = Application.stop(:devton)
      :ok = Application.stop(:commanded)

      {:ok, _apps} = Application.ensure_all_started(:devton)
    end)
  end
end

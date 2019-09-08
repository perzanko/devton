defmodule Devton.Subscriptions.Commands.PerformSend do
  @enforce_keys [
    :uuid,
    :sent_articles,
    :suggested_articles,
    :random,
  ]
  defstruct [
    :uuid,
    :sent_articles,
    :suggested_articles,
    :random,
  ]
end

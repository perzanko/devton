defmodule Devton.Subscriptions.Commands.PerformSend do
  @enforce_keys [
    :uuid,
    :sent_articles,
    :suggested_articles,
    :random,
    :popularity_of_tags,
  ]
  defstruct [
    :uuid,
    :sent_articles,
    :suggested_articles,
    :random,
    :popularity_of_tags,
  ]
end

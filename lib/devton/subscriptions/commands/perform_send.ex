defmodule Devton.Subscriptions.Commands.PerformSend do
  @enforce_keys [
    :uuid,
    :sent_articles,
    :suggested_tags_articles,
    :suggested_other_articles,
  ]
  defstruct [
    :uuid,
    :sent_articles,
    :suggested_tags_articles,
    :suggested_other_articles,
  ]
end

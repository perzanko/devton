defmodule Devton.Subscriptions.Events.SendPerformed do
  @derive [Jason.Encoder]
  defstruct [
    :uuid,
    :article_id,
    :sent_at,
  ]
end

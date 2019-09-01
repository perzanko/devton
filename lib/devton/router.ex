defmodule Devton.Router do
  use Commanded.Commands.Router

  dispatch(
    [
      Devton.Workspaces.Commands.CreateWorkspace,
      Devton.Workspaces.Commands.EnableWorkspace,
      Devton.Workspaces.Commands.DisableWorkspace,
    ],
    to: Devton.Workspaces.Aggregates.Workspace,
    identity: :uuid
  )

  dispatch(
    [
      Devton.Library.Commands.CreateTag,
    ],
    to: Devton.Library.Aggregates.Tag,
    identity: :id
  )

  dispatch(
    [
      Devton.Library.Commands.CreateArticle,
    ],
    to: Devton.Library.Aggregates.Article,
    identity: :id
  )

  dispatch(
    [
      Devton.Subscriptions.Commands.CreateSubscription,
      Devton.Subscriptions.Commands.DeactivateSubscription,
    ],
    to: Devton.Subscriptions.Aggregates.Subscription,
    identity: :uuid
  )
end

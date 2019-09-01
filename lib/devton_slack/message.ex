defmodule DevtonSlack.Message do
  def welcome(user_id) do
    "
Hi <@#{user_id}>, I'm _Devton_ :wave:
I can help you to stay up to date as a developer! :male-technologist:
Let's create your own *dev.to* newsletter!
    "
  end

  def help do
    "
> *Usage*
> ```
devton subscribe (--tag --day --time)              # Create new subscription
devton unsubscribe (--id)                          # Remove subscription
devton status                                      # Show all active subscriptions
```
>
> *Options*
> ```
--tag, -t               # Subscription tag (eg. \"javascript,webdev\")
--day, -d               # Day the articles are sent (eg. \"monday,tuesday\"). To send everyday use \"*\"
--time, -m              # Time the articles are sent (eg. \"12:00\"). Devton can send more than once a day, if you use \"10:00,12:30\"
--id                    # Subscription id
--help, -h              # Show this screen
```
>
> *Examples*
> ```
devton subscribe --time 12:00 --day * --tag javascript,webdev
```
> _It creates newsletter subscription for *javascript* and *webdev* tags and sets sending time *at 12:00 pm on every day*._
> ```
devton subscribe -m 8:00,21:00 -d monday,wednesday,friday -t node,react,typescript
```
> _It creates newsletter subscription for *node*, *react* and *typescript* tags and sets sending time *at 8:00 am and 9:00 pm on every Monday, Wednesday and Friday*._
    "
  end

  def unsubscribed_success(subscription_id) do
    ":white_check_mark: You have been successfully unsubscribed #{subscription_id}}!"
  end

  def unsubscribed_fail(subscription_id) do
    "Subscription with id #{subscription_id} not found."
  end

  def subscribed_success(tags) do
    ":white_check_mark: You have been successfully subscribed! Tags: *#{Enum.join tags, ", "}*"
  end

  def subscribed_fail do
    "Unexpected error occured. Please try again later."
  end

  def invalid_command do
    "Command invalid. You can see available commands using `devton --help`"
  end

  def invalid_day do
    "Invalid `--day` argument"
  end

  def invalid_time do
    "Invalid `--time` argument"
  end

  def status(subscriptions) do
     List.foldl(subscriptions, "", fn subscription, acc ->
      acc <> "
• `#{subscription.uuid}`
> Tags: *#{Enum.join subscription.tags, ", "}*
> Cron: #{Enum.join subscription.cron_tabs, ", "}"
    end)
  end
end

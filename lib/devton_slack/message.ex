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
Usage
```
devton subscribe [options]
devton unsubscribe

-c, --cron             # Cron configuration for newsletter
-t, --tags             # Subscription tags
-h, --help             # Show this screen
```

Example
```
devton subscribe --cron \"0 12 * * 1\" --tags \"javascript,webdev\"
```
It creates newsletter subscription for *javascript* and *webdev* tags and sets sending time *at 12:00 pm on every Monday*.
    "
  end
end

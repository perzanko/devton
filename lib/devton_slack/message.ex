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
> Usage
> ```
devton subscribe (--tag --day --time)
devton unsubscribe (--id)
devton status

-t, --tag             # Subscription tag (eg. \"javascript,webdev\")
-d, --day              # Day the articles are sent (eg. \"monday,tuesday\"). To send everyday use \"*\"
-tm, --time            # Time the articles are sent (eg. \"12:00\"). Devton can send more than once a day, if you use \"10:00,12:30\"
--id                   # Subscription id
-h, --help             # Show this screen
```
>
> Examples
> ```
devton subscribe --time 12:00 --day * --tag javascript,webdev
```
> It creates newsletter subscription for *javascript* and *webdev* tags and sets sending time *at 12:00 pm on every day*.
> ```
devton subscribe --time 8:00,21:00 --day monday,wednesday,friday --tags node,react,typescript
```
> It creates newsletter subscription for *node*, *react* and *typescript* tags and sets sending time *at 8:00 am and 9:00 pm on every Monday, Wednesday and Friday*.
    "
  end

  def unsubscribed do
    ":white_check_mark: You have been successfully unsubscribed! "
  end

  def invalid_command do
    "Command invalid. You can see available commands using `devton --help`"
  end

  def status do
    "status"
  end
end

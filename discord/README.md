# Discord Utilities Documentation
##### `no <>` = Necessary, `<>` = Optional

### 1) `Discord:Invite(Invite: string)`
- Opens up your browser and joins the Discord server the invite leads to

Usage:
```lua
Discord:Invite("invite")
```

---

### 2) `Discord:Webhook(Webhook: string, Function: string, <Data>: table)`
- Lets you use your Discord webhook to its fullest extent

Usage:
```lua
-- Send a webhook message
Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Message", {
    Content = "Hello world!"
})

-- Send a webhook embed
Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Embed", {
    Content = "Hello world!",
    Name = "Webhook #1",
    Avatar = "https://link.com/Avatar.jpg",
    Author = "Author Name",
    AuthorImage = "https://link.com/AuthorImage.png",
    Title = "Embed Title",
    Description = "Embed Description",
    Color = "FFFFFF",
    Footer = "Footer Text",
    Fields = {
        {
            Name = "Field Name",
            Text = "Field Value/Text",
            InLine = true
        }
    }
})

-- Update the webhook's name & avatar
Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Update", {
    Name = "New Webhook Name",
    Avatar = "https://link.com/NewAvatar.jpeg"
})

-- Delete the webhook
Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Delete")

-- Get a webhook's information
local WebhookInfo = Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Info")

-- Check if a webhook is valid
local WebhookValid = Discord:Webhook("https://discord.com/api/webhook/webhook_token", "Check")
```
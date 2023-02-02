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
    Title = "Embed Title",
    TitleUrl = "https://google.com/" -- Must have "Title" before adding this
    Description = "Embed Description",
    Color = "FFFFFF", -- Works with strings ("0xFFFFFF", "FFFFFF"), hexadecimal integers (0xFFFFFF) and Color3 values (Color3.new(1, 1, 1), Color3.fromRGB(255, 255, 255)
    Author = "Author Name",
    AuthorImage = "https://link.com/AuthorImage.png", -- Must have "Author" before adding this
    Footer = "Footer Text",
    FooterImage = "https://link.com/FooterImage.png", -- Must have "Footer" before adding this
    Image = "https://link.com/Image.png",
    Thumbnail = "https://link.com/Thumbnail.png",
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
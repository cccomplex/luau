local Discord = {}

_G.bit32 = bit32
local Base64Encode = (syn and syn.crypt.base64.encode) or (fluxus and fluxus.crypt.base64.encode) or (crypt and crypt.base64encode) or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/iskolbin/lbase64/master/base64.lua"))().encode
local Request = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

function Send(Webhook, Method, Data, Headers)
    Headers = Headers or {
        ["Content-Type"] = "application/json",
    }
    
    local RequestData = {
        Url = Webhook,
        Method = Method,
        Headers = Headers
    }
    
    if Method ~= "GET" and Method ~= "HEAD" then
        RequestData.Body = game:GetService("HttpService"):JSONEncode(Data)
    end
    
    return Request(RequestData)
end

function Discord:Invite(Invite)
    for Port = 6463, 6472 do
        Send("http://127.0.0.1:" .. Port .."/rpc?v=1", "POST", {
               ["args"] = {
                   ["code"] = Invite,
               },
               ["cmd"] = "INVITE_BROWSER",
               ["nonce"] = "."
            },
            {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com",
            }
        )
    end
end

function Discord:Webhook(URL, Type, Data)
    Data = Data or {}
    local WebhookData = {}

    local function ReturnAvatar(Avatar)
        if Avatar == nil or Avatar == "" then return "" end

        local Extension = string.match(Avatar, "%.%w+$")

        for _, AllowedExtension in next, {".png", ".jpeg", ".jpg", ".gif"} do
            if Extension == AllowedExtension then
                if Avatar:find("http") then
                    return "data:image/" .. Extension:gsub("%.", "") .. ";base64," .. Base64Encode(Request({Url = Avatar}).Body)
                elseif isfile(Avatar) then
                    return "data:image/" .. Extension:gsub("%.", "") .. ";base64," .. Base64Encode(readfile(Avatar))
                end
            end
        end
    end

    local function ReturnFields(Fields)
        if Fields == nil then return {} end

        local Table = {}

        for _, Field in ipairs(Fields) do
            table.insert(Table, {
                ["name"] = Field.Name,
                ["value"] = Field.Text,
                ["inline"] = Field.InLine or false,
            })
        end

        return Table
    end

    local function ReturnColor(Color)
        if typeof(Color) == "Color3" then
            Color = "0x" .. Color:ToHex()
        elseif typeof(Color) == "string" then
            if not string.find(Color, "0x") then
                Color = "0x" .. Color:upper()
            end
        end

        return tonumber(Color)
    end

    local Types = {
        ["Message"] = "POST",
        ["Embed"] = "POST",
        ["Update"] = "PATCH",
        ["Delete"] = "DELETE",
        ["Info"] = "GET",
        ["Check"] = "GET"
    }
    
    Type = string.upper(string.sub(Type:lower(), 1, 1)) .. string.sub(Type:lower(), 2, -1)

    if not Types[Type] then return end

    if Type == "Message" then
        if Data.Content then
            WebhookData["content"] = Data.Content
        end
    end

    if Type == "Embed" then
        if Data.Content then
            WebhookData["content"] = Data.Content
        end
        if Data.Name then
            WebhookData["username"] = Data.Name
        end
        if Data.Avatar then
            WebhookData["avatar_url"] = Data.Avatar
        end
        if Data.Content then
            WebhookData["content"] = Data.Content
        end
        if Data.Name then
            WebhookData["username"] = Data.Name
        end
        if Data.Title then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end

            WebhookData["embeds"][1]["title"] = Data.Title
            
            if Data.TitleUrl then
                WebhookData["embeds"][1]["url"] = Data.TitleUrl
            end
        end
        if Data.Description then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            
            WebhookData["embeds"][1]["description"] = Data.Description
        end
        if Data.Color then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end

            WebhookData["embeds"][1]["color"] = ReturnColor(Data.Color)
        end
        if Data.Fields then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            
            WebhookData["embeds"][1]["fields"] = ReturnFields(Data.Fields)
        end
        if Data.Author then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            if WebhookData["embeds"][1]["author"] == nil then
                WebhookData["embeds"][1]["author"] = {}
            end

            WebhookData["embeds"][1]["author"]["name"] = Data.Author
            
            if Data.AuthorImage then
                WebhookData["embeds"][1]["author"]["icon_url"] = Data.AuthorImage
            end
        end
        if Data.Footer then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            if WebhookData["embeds"][1]["footer"] == nil then
                WebhookData["embeds"][1]["footer"] = {}
            end

            WebhookData["embeds"][1]["footer"]["text"] = Data.Footer

            if Data.FooterImage then
                WebhookData["embeds"][1]["footer"]["icon_url"] = Data.FooterImage
            end
        end
        if Data.Image then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            if WebhookData["embeds"][1]["image"] == nil then
                WebhookData["embeds"][1]["image"] = {}
            end
            
            WebhookData["embeds"][1]["image"]["url"] = Data.Image
        end
        if Data.Thumbnail then
            if WebhookData["embeds"] == nil then
                WebhookData["embeds"] = {}
            end
            if WebhookData["embeds"][1] == nil then
                WebhookData["embeds"][1] = {}
            end
            if WebhookData["embeds"][1]["thumbnail"] == nil then
                WebhookData["embeds"][1]["thumbnail"] = {}
            end
            
            WebhookData["embeds"][1]["thumbnail"]["url"] = Data.Image
        end
    end

    if Function == "Update" then
        if Data.Name then
            WebhookData["name"] = Data.Name
        end
        if Data.Avatar then
            WebhookData["avatar"] = ReturnAvatar(Data.Avatar)
        end
    end

    local RequestData = Send(URL, Types[Type], WebhookData)

    if Function == "Info" then
        return (Data.InLua and game:GetService("HttpService"):JSONDecode(RequestData.Body)) or RequestData.Body
    elseif Function == "Check" then
        local Info = game:GetService("HttpService"):JSONDecode(RequestData.Body)
        return Info.code == nil or Info.code ~= 10015 or Info.code ~= 10016
    end
end

return Discord
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

function Discord:Webhook(Webhook, Function, Data)
    Data = Data or {}
    
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

    local DataTypes = {
        ["Message"] = {
            Data = {
                ["content"] = Data.Content or ""
            },
            Method = "POST"
        },
        ["Embed"] = {
            Data = {},
            Method = "POST"
        },
        ["Update"] = {
            Data = {},
            Method = "PATCH"
        },
        ["Delete"] = {
            Data = {},
            Method = "DELETE"
        },
        ["Info"] = {
            Data = {},
            Method = "GET"
        },
        ["Check"] = {
            Data = {},
            Method = "GET"
        }
    }

    Function = string.upper(string.sub(Function:lower(), 1, 1)) .. string.sub(Function:lower(), 2, -1)
    
    if Function == "Embed" then
        if Data.Content then
            DataTypes[Function].Data["content"] = Data.Content
        end
        if Data.Name then
            DataTypes[Function].Data["username"] = Data.Name
        end
        if Data.Avatar then
            DataTypes[Function].Data["avatar_url"] = Data.Avatar
        end
        if Data.Content then
            DataTypes[Function].Data["content"] = Data.Content
        end
        if Data.Name then
            DataTypes[Function].Data["username"] = Data.Name
        end
        if Data.Author then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            if DataTypes[Function].Data["embeds"][1]["author"] == nil then
                DataTypes[Function].Data["embeds"][1]["author"] = {}
            end
            DataTypes[Function].Data["embeds"][1]["author"]["name"] = Data.Author
        end
        if Data.AuthorImage then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            if DataTypes[Function].Data["embeds"][1]["author"] == nil then
                DataTypes[Function].Data["embeds"][1]["author"] = {}
            end
            DataTypes[Function].Data["embeds"][1]["author"]["icon_url"] = Data.AuthorImage
        end
        if Data.Title then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            DataTypes[Function].Data["embeds"][1]["title"] = Data.Title
        end
        if Data.Description then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            DataTypes[Function].Data["embeds"][1]["description"] = Data.Description
        end
        if Data.Color then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            DataTypes[Function].Data["embeds"][1]["color"] = ReturnColor(Data.Color)
        end
        if Data.Footer then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            if DataTypes[Function].Data["embeds"][1]["footer"] == nil then
                DataTypes[Function].Data["embeds"][1]["footer"] = {}
            end
            DataTypes[Function].Data["embeds"][1]["footer"]["text"] = Data.Footer
        end
        if Data.Fields then
            if DataTypes[Function].Data["embeds"] == nil then
                DataTypes[Function].Data["embeds"] = {}
            end
            if DataTypes[Function].Data["embeds"][1] == nil then
                DataTypes[Function].Data["embeds"][1] = {}
            end
            DataTypes[Function].Data["embeds"][1]["fields"] = ReturnFields(Data.Fields)
        end
    end
    
    if Function == "Update" then
        if Data.Name then
            DataTypes[Function].Data["name"] = Data.Name
        end
        if Data.Avatar then
            DataTypes[Function].Data["avatar"] = ReturnAvatar(Data.Avatar)
        end
    end

    if not DataTypes[Function] then return end

    local RequestData = Send(Webhook, DataTypes[Function].Method, DataTypes[Function].Data)

    if Function == "Info" then
        return (Data.InLua and game:GetService("HttpService"):JSONDecode(RequestData.Body)) or RequestData.Body
    elseif Function == "Check" then
        local Info = game:GetService("HttpService"):JSONDecode(RequestData.Body)
        return Info.code == nil or Info.code ~= 10015 or Info.code ~= 10016
    end
end

return Discord
local Discord = {}

local Request = (syn and syn.request) or (http and http.request) or http_request or request
if Request == nil then return end

function Discord:Invite(Invite)
    for Port = 6463, 6472 do
        Request({
            Url = "https://127.0.0.1:" .. Port .."/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["origin"] = "https://discord.com",
            },
            Body = game:GetService("HttpService"):JSONEncode({
               ["args"] = {
                   ["code"] = Invite,
               },
               ["cmd"] = "INVITE_BROWSER",
               ["nonce"] = "."
           })
        })
    end
end

return Discord
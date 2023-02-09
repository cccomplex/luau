local Utility = {
    Connections = {},
    Coroutines = {}
}

function Utility:GetService(...)
    local Data = (type(...) == "table" and ...) or (... ~= nil and {...}) or {}

    if table.getn(Data) == 1 then
        return game:GetService(Data[1])
    else
        local Services = {}
        
        for _, Service in ipairs(Data) do
            Services[table.getn(Services) + 1] = game:GetService(Service)
        end
        
        return unpack(Services)
    end
end

function Utility:Connection(Data)
    local Signal, Name, Callback; do
        Signal = ((Data ~= nil and Data.Signal ~= nil) and Data.Signal) or self:GetService("RunService").RenderStepped
        Name = ((Data ~= nil and Data.Name ~= nil) and Data.Name) or #self.Connections + 1
        Callback = ((Data ~= nil and Data.Callback ~= nil) and Data.Callback) or function() end
    end

    local Connection = Signal:Connect(Callback)

    self.Connections[Name] = Connection

    return Connection
end

function Utility:Coroutine(Data)
    local Name, Callback, Arguments; do
        Name = ((Data ~= nil and Data.Name ~= nil) and Data.Name) or #self.Coroutines + 1
        Callback = ((Data ~= nil and Data.Callback ~= nil) and Data.Callback) or function() end
        Arguments = ((Data ~= nil and Data.Arguments ~= nil) and ((type(Data.Arguments) == "table" and Data.Arguments) or {Data.Arguments}))
    end

    local Coroutine = {}

    Coroutine.Function = coroutine.create(function(Arguments)
        while task.wait() do
            pcall(Callback, unpack(Arguments))
        end
    end)
    
    self.Coroutines[Name] = Coroutine
    
    coroutine.resume(Coroutine.Function, Arguments)

    function Coroutine:Disconnect()
        coroutine.close(Coroutine.Function)
    end
    
    return Coroutine
end

function Utility:Unload(Type, Data)
    local Types = {
        ["Connection"] = function(Name)
            if self.Connections[Name] then
                self.Connections[Name]:Disconnect()
            end
        end,
        ["Coroutine"] = function(Name)
            if self.Coroutines[Name] then
                self.Coroutines[Name]:Disconnect()
            end
        end,
        ["Connections"] = function(Names)
            if Names ~= nil then
                for _, Name in next, Names do
                    if self.Connections[Name] then
                        self.Connections[Name]:Disconnect()
                    end
                end
            else
                for _, Connection in next, self.Connections do
                    Connection:Disconnect()
                end
            end
        end,
        ["Coroutines"] = function(Names)
            if Names ~= nil then
                for _, Name in next, Names do
                    if self.Coroutines[Name] then
                        self.Coroutines[Name]:Disconnect()
                    end
                end
            else
                for _, Coroutine in next, self.Coroutines do
                    Coroutine:Disconnect()
                end
            end
        end,
        ["All"] = function()
            for _, Connection in next, self.Connections do
                Connection:Disconnect()
            end
            for _, Coroutine in next, self.Coroutines do
                Coroutine:Disconnect()
            end
        end
    }

    if Type ~= nil then
        pcall(Types[Type], Data)
    else
        pcall(Types["All"], Data)
    end
end

function Utility:Create(Name, Parent, Properties)
    if not Drawing then return end
    
    if typeof(Parent) == "table" then
        Parent, Properties = Properties, Parent
    end

    local DrawingObjects = {"Line", "Text", "Image", "Circle", "Square", "Quad", "Triangle"}

    local Object; do
        if table.find(DrawingObjects, Name) then
            Object = Drawing.new(Name)
        else
            if Parent ~= nil then
                Object = Instance.new(Name, Parent)
            else
                Object = Instance.new(Name, workspace)
            end 
        end
    end

    Properties = Properties or {}

    for Property, Value in next, Properties do
        Object[Property] = Value
    end

    return Object
end

function Utility:Data()
    local FPS, Ping, Memory = 0, 9e9, 0
    
    local Index = 1; local FPSConnection; FPSConnection = self:Connection({
        Callback = function(Step)
            FPS += 1 / Step
            Index += 1
        end
    }); task.wait(0.1); FPSConnection:Disconnect()

    FPS /= Index

    local PrimarySuccess, _ = pcall(function()
        self:GetService("Stats").PerformanceStats.Ping:GetValue()
    end)

    local SecondarySuccess, _ = pcall(function()
        self:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(math.round(2 / wait()))
    end)
    
    if PrimarySuccess then
        Ping = self:GetService("Stats").PerformanceStats.Ping:GetValue()
    elseif SecondarySuccess then
        local SecondaryOutput = self:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(math.round(2 / wait()))
        SecondaryOutput = SecondaryOutput:split(" ")[1]

        Ping = tonumber(SecondaryOutput)
    else
        Ping = self:GetService("Players").LocalPlayer:GetNetworkPing() * 2000
    end
    
    local Success, _ = pcall(function()
        self:GetService("Stats"):GetTotalMemoryUsageMb()
    end)

    if Success then
        Memory = self:GetService("Stats"):GetTotalMemoryUsageMb()
    end

    return {
        ["FPS"] = FPS,
        ["Ping"] = Ping,
        ["Memory"] = Memory
    }
end

function Utility:ServerHop(MinimumPlayers, AscOrDsc)
    if typeof(MinimumPlayers) == "boolean" then
        MinimumPlayers, AscOrDsc = AscOrDsc, MinimumPlayers
    end
    
    print(MinimumPlayers, AscOrDsc)
    
    local HttpService, TeleportService = self:GetService("HttpService", "TeleportService")
    
    local List = {}; do
        local Data = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. ((AscOrDsc and "Asc") or "Dsc") .. "&limit=100")).data
        local Temp = {}
        
        for _, Server in next, Data do
            if Server.playing and Server.id ~= game.JobId then
                Temp[#Temp + 1] = Server
            end
        end
        
        for Index = 1, #Temp do
            local RandomIndex = Random.new():NextInteger(1, #Temp)
            List[#List + 1] = Temp[RandomIndex]
        end
    end
    
    local function MinimumPlayersCheck(Server)
        if MinimumPlayers ~= nil then
            return Server.playing > MinimumPlayers
        else
            return true
        end
    end
    
    for _, Server in next, List do
        if Server.playing < Server.maxPlayers and MinimumPlayersCheck(Server) then
            local Success, Error = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, Server.id)
            if not Success then return end
        end
    end
end

function Utility:Generate(Type, Length, PunctuationIncluded)
    if type(Length) == "boolean" then
        Length, PunctuationIncluded = PunctuationIncluded, Length
    end
    
    Length = Length or 8
    
    local Output = ""
    local Letters, Numbers, Symbols, Punctuation = setmetatable({}, {
        __add = function(T1, T2)
            for _, Value in ipairs(T2) do
                table.insert(T1, Value)
            end
            return T1
        end
    }),
    setmetatable({}, {
        __add = function(T1, T2)
            for _, Value in ipairs(T2) do
                table.insert(T1, Value)
            end
            return T1
        end
    }),
    setmetatable({}, {
        __add = function(T1, T2)
            for _, Value in ipairs(T2) do
                table.insert(T1, Value)
            end
            return T1
        end
    }), 
    setmetatable({".", ",", "?", ";", "!", ":", "'", "(", ")", "[", "]", '"', "-", "/", "@", "{", "}", "*"}, {
        __sub = function(T1, T2)
            for _, Value in ipairs(T2) do
                if table.find(T1, Value) then
                    table.remove(T1, table.find(T1, Value))
                end
            end
            return T1
        end
    })

    for Index = 65, 90 do
        table.insert(Letters, utf8.char(Index))
    end
    for Index = 97, 122 do
        table.insert(Letters, utf8.char(Index))
    end
    for Index = 48, 57 do
        table.insert(Numbers, utf8.char(Index))
    end
    for Index = 32, 47 do
        table.insert(Symbols, utf8.char(Index))
    end
    for Index = 58, 64 do
        table.insert(Symbols, utf8.char(Index))
    end
    for Index = 91, 96 do
        table.insert(Symbols, utf8.char(Index))
    end
    for Index = 123, 126 do
        table.insert(Symbols, utf8.char(Index))
    end

    local Characters = {}

    if Type == "Letters" then
        Characters += Letters

        repeat
            Output ..= Characters[Random.new():NextInteger(1, #Characters)]
        until string.len(Output) == Length
    elseif Type == "Numbers" then
        Characters += Numbers

        repeat
            Output ..= Characters[Random.new():NextInteger(1, #Characters)]
        until string.len(Output) == Length
    elseif Type == "Characters" then
        Characters += Letters
        Characters += Numbers

        repeat
            Output ..= Characters[Random.new():NextInteger(1, #Characters)]
        until string.len(Output) == Length
    elseif Type == "Symbols" then
        Characters += Symbols

        if not PunctuationIncluded then
            Characters -= Punctuation
        end

        repeat
            Output ..= Characters[Random.new():NextInteger(1, #Characters)]
        until string.len(Output) == Length
    elseif Type == "All" then
        Characters += Letters
        Characters += Numbers
        Characters += Symbols

        if not PunctuationIncluded then
            Characters -= Punctuation
        end
        
        repeat
            Output ..= Characters[Random.new():NextInteger(1, #Characters)]
        until string.len(Output) == Length
    end

    return Output
end

return Utility
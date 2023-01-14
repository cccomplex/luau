local Utility = {
    Connections = {}
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
        Signal = ((Data ~= nil and Data.Signal ~= nil) and Data.Signal) or Utility:GetService("RunService").RenderStepped
        Name = ((Data ~= nil and Data.Name ~= nil) and Data.Name) or #Utility.Connections + 1
        Callback = ((Data ~= nil and Data.Callback ~= nil) and Data.Callback) or function() end
    end

    local Connection = Signal:Connect(Callback)
    Utility.Connections[Name] = Connection

    return Connection
end

function Utility:Create(Name, Parent, Properties)
    if typeof(Parent) == "table" then
        Parent, Properties = Properties, Parent
    end

    local Object; do
        if Parent ~= nil then
            Object = Instance.new(Name, Parent)
        else
            Object = Instance.new(Name, workspace)
        end
    end

    for Property, Value in next, Properties do
        Object[Property] = Value
    end

    return Object
end

function Utility:Draw(Name, Properties)
    if not Drawing or not Drawing.new then return end

    local Object = Drawing.new(Name)
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
        Utility:GetService("Stats").PerformanceStats.Ping:GetValue()
    end)

    local SecondarySuccess, _ = pcall(function()
        Utility:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(math.round(2 / wait()))
    end)
    
    if PrimarySuccess then
        Ping = Utility:GetService("Stats").PerformanceStats.Ping:GetValue()
    elseif SecondarySuccess then
        local SecondaryOutput = Utility:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(math.round(2 / wait()))
        SecondaryOutput = SecondaryOutput:split(" ")[1]

        Ping = tonumber(SecondaryOutput)
    else
        Ping = Utility:GetService("Players").LocalPlayer:GetNetworkPing() * 2000
    end
    
    local Success, _ = pcall(function()
        Utility:GetService("Stats"):GetTotalMemoryUsageMb()
    end)

    if Success then
        Memory = Utility:GetService("Stats"):GetTotalMemoryUsageMb()
    end

    return {
        ["FPS"] = FPS,
        ["Ping"] = Ping,
        ["Memory"] = Memory
    }
end

return Utility
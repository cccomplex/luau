# Utility Documentation
##### `no <>` = Necessary, `<>` = Optional

### 1) `Utility:GetService(ServiceNames: table, string or tuple)`
- Returns one or more Services when used

Usage:
```lua
Utility:GetService("Players")
Utility:GetService("Players", "RunService")
Utility:GetService({"Players"})
Utility:GetService({"Players", "RunService"})
```

### 2) `Utility:Connection(<Data>: table)`
- Creates a "RBXScriptConnection" to a "RBXScriptSignal" that will run the callback given under a key value or an index value

Usage:
```lua
-- [Note] These values given are completely optional, running just "Utility:Connection()" will create a connection the the "RenderStepped" event on the "RunService" and call an empty closure.
Utility:Connection({
    Name = "TestConnection",
    Signal = game:GetService("RunService"),
    Callback = function()
        print("Hello world!")
    end
})
```

### 3) `Utility:Create(Name: string, <Parent>: Instance, <Properties>: table)`
- Creates an Instance

Usage:
```lua
Utility:Create("Part")
Utility:Create("Part", {
    Color = Color3.new(1, 0, 0)
})
Utility:Create("Part", workspace, {
    Color = Color3.new(1, 0, 0)
})
```

### 4) `Utility:Draw(Name: string, <Properties>: table)`
- Creates a Drawing object

Usage:
```lua
Utility:Draw("Line")
Utility:Draw("Line", {
    Visible = true,
    Color = Color3.new(1, 1, 1),
    Transparency = 1
})
```

### 5) `Utility:Data()`
- Returns client data (frames per second, ping, and memory usage)

Usage:
```lua
local Data = Utility:Data()

print(Data.FPS, "FPS")
print(Data.Ping, "ms")
print(Data.Memory, "MB")
```
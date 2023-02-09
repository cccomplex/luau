# Utility Documentation
##### `no <>` = Necessary, `<>` = Optional

### 1) `Utility:GetService(ServiceNames: table or string(s))`
- Returns one or more Services when used

Usage:
```lua
-- Retrieving the "Players" service
Utility:GetService("Players")

-- Retrieving the "Players" and "RunService" service
Utility:GetService("Players", "RunService")

-- Retrieving the "Players" service (in a table)
Utility:GetService({"Players"})

-- Retrieving the "Players" and "RunService" service (in a table)
Utility:GetService({"Players", "RunService"})
```

---

### 2) `Utility:Connection(<Data>: table)`
- Creates a "RBXScriptConnection" to a "RBXScriptSignal" that will run the callback given under a key value or an index value

Usage:
```lua
-- Default name is just an integer based on how many connections you have already made with this function, default signal is the "game:GetService("RunService").RenderStepped" event, default callback is an empty closure

local Connection = Utility:Connection({
    Name = "TestConnection",
    Signal = game:GetService("RunService").RenderStepped,
    Callback = function()
        print("Hello world!")
    end
})

-- Disconnects the connection
Connection:Disconnect()
```

---

### 3) `Utility:Coroutine(<Data>: table)`
- Creates a coroutine that will run the callback given under a key value or an index value

Usage:
```lua
-- Default name is just an integer based on how many connections you have already made with this function, default callback is an empty closure, "Arguments" is optional

local Coroutine = Utility:Coroutine({
    Name = "TestCoroutine",
    Callback = function(...)
        print(...)
    end,
    Arguments = {"Hello", "world!"}
})

-- Stops the coroutine
Coroutine:Disconnect()
```

---

### 4) `Utility:Unload(<Type>: string, <Data>: Instance, string or table)`
- Disconnects connections and stops coroutines from running

Usage:
```lua
-- Disconnects all connections and stops all coroutines
Utility:Unload()

-- Disconnects all connections and stops all coroutines
Utility:Unload("All")

-- Disconnects the connection with the key value "ConnectionName" 
Utility:Unload("Connection", "ConnectionName")

-- Stops the coroutine with the key value "CoroutineName" 
Utility:Unload("Coroutine", "CoroutineName")

-- Disconnects all connections
Utility:Unload("Connections")

-- Disconnects connections with the key values "ConnectionName1", "ConnectionName2" and "ConnectionName3"
Utility:Unload("Connections", {"ConnectionName1", "ConnectionName2", "ConnectionName3"})

-- Stops all coroutines
Utility:Unload("Coroutines")

-- Stops coroutines with the key values "CoroutineName1", "CoroutineName2" and "CoroutineName3"
Utility:Unload("Coroutines", {"CoroutineName1", "CoroutineName2", "CoroutineName3"})
```

---

### 5) `Utility:Create(Name: string, <Parent>: Instance, <Properties>: table)`
- Creates either a Drawing object or an Instance

Usage:
```lua
-- Creating a "Part" Instance
Utility:Create("Part")

-- Creating a "Part" Instance with new property values
Utility:Create("Part", {
    Color = Color3.new(1, 0, 0)
})

-- Creating a "Part" Instance in the parent "workspace" with new property values
Utility:Create("Part", workspace, {
    Color = Color3.new(1, 0, 0)
})

-- Creating a "Line" object
Utility:Create("Line")

-- Creating a "Line" object with new property values
Utility:Create("Line", {
    Visible = true,
    Color = Color3.new(1, 0, 0),
    Transparency = 0.5
})
```

---

### 6) `Utility:Data()`
- Returns client data

Usage:
```lua
local Data = Utility:Data()

-- Client's frames per second
local FPS = Data.FPS
print(FPS, "FPS")

-- Client's ping
local Ping = Data.Ping
print(Ping, "ms")

-- Client's memory usage (in megabytes)
local Memory = Data.Memory
print(Memory, "MB")
```

---

### 7) `Utility:ServerHop(<MinimumPlayers>: integer, <AscOrDsc>: boolean)`
- Hops servers in the game you are playing

Usage:
```lua
-- No minimum set & data is in descending order
Utility:ServerHop()

-- Minimum players set @ 5 & data is in descending order
Utility:ServerHop(5)

-- No minimum set & data is in ascending order
Utility:ServerHop(true)

-- Minimum players set @ 3 & data is in ascending order
Utility:ServerHop(3, false)
```

---

### 8) `Utility:Generate(Type: string, <Length>: integer, <PunctuationIncluded>: boolean)`
- Generates a random set of characters with a set length and with/without characters for punctuation

Usage:
```lua
-- Default length is 8 characters, default "PunctuationIncluded" value is false

-- Generates a set of characters using only letters
print(Utility:Generate("Letters")) -- Has a length of 8 characters
print(Utility:Generate("Letters", 16)) -- Has a length of 16 characters

-- Generates a set of characters using only numbers
print(Utility:Generate("Numbers")) -- Has a length of 8 characters
print(Utility:Generate("Numbers", 16)) -- Has length of 16 characters

-- Generates a set of characters using both letters and numbers
print(Utility:Generate("Characters")) -- Has a length of 8 characters
print(Utility:Generate("Characters", 16)) -- Has a length of 16 characters

-- Generates a set of characters using only symbols
print(Utility:Generate("Symbols")) -- Has a length of 8 characters, no punctuation included
print(Utility:Generate("Symbols", 16)) -- Has a length of 16 characters, no punctuation included
print(Utility:Generate("Symbols", true))  -- Has a length of 8 characters, punctuation included
print(Utility:Generate("Symbols", 16, true))  -- Has a length of 16 characters, punctuation included

-- Generates a set of characters using all characters
print(Utility:Generate("All")) -- Has a length of 8 characters, no punctuation included
print(Utility:Generate("All", 16)) -- Has a length of 16 characters, no punctuation included
print(Utility:Generate("All", true))  -- Has a length of 8 characters, punctuation included
print(Utility:Generate("All", 16, true))  -- Has a length of 16 characters, punctuation included
```

---

### 9) `Utility:Players(<Type>: string)`
- Returns a table of players with the conditions of the type given being met

Usage:
```lua
-- Returns all players
local Players = Utility:Players()
local Players = Utility:Players("All")

-- Returns every player except yourself
local Players = Utility:Players("Others")
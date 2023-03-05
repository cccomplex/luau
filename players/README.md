# Players Library Documentation
##### `no <>` = Necessary, `<>` = Optional

### 1) `Players:Get(<Type>: string, <Self>: boolean)`
- Returns a table of players with the conditions given being met

Usage:
```lua
-- Returns all players
local PlayerList = Players:Get()
local PlayerList = Players:Get("All")

-- Returns every player except yourself
local PlayerList = Players:Get("Others")

-- Returns every player that is your friend
local PlayerList = Players:Get("Friends")
local PlayerList = Players:Get("Friends", true) -- Returns yourself in the output

-- Returns every player that isn't your friend
local PlayerList = Players:Get("Non-Friends")
local PlayerList = Players:Get("Non-Friends", false) -- Does not return yourself in the output

-- Returns every player on your team
local PlayerList = Players:Get("Team")
local PlayerList = Players:Get("Team", false) -- Does not return yourself in the output

-- Returns every player not on your team
local PlayerList = Players:Get("Non-Team")
local PlayerList = Players:Get("Non-Team", true) -- Returns yourself in the output
```

---

### 2) `Players:Find(Type: string, <Input>: string)`
- Returns a player with the conditions given being met or by finding the input given within the player's "Name" or "DisplayName"

Usage:
```lua
-- Finding a specific player in the game via part of their Name/DisplayName
local Player = Players:Find("inputhere")

-- Finding the closest player in the game
local Player, Distance = Players:Find("Closest")

-- Finding the farthest player in the game
local Player, Distance = Players:Find("Farthest")

-- Finding the newest player in the game
local Player, Age = Players:Find("Newest")

-- Finding the oldest player in the game
local Player, Age = Players:Find("Oldest")
```
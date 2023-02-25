# Players Library Documentation
##### `no <>` = Necessary, `<>` = Optional
--
### 1) `Players:Get(<Type>: string)`
- Returns a table of players with the conditions of the type given being met

Usage:
```lua
-- Returns all players
local PlayerList = Players:Get()
local PlayerList = Players:Get("All")

-- Returns every player except yourself
local PlayerList = Players:Get("Others")

-- Returns every player that is your friend
local PlayerList = Players:Get("Friends")

-- Returns every player that isn't your friend
local PlayerList = Players:Get("Non-Friends")

-- Returns every player on your team
local PlayerList = Players:Get("Team")

-- Returns every player not on your team
local PlayerList = Players:Get("Non-Team")
```

---

### 2) `Players:Find(Type: string, <Input>: string)`
- Returns a player with the conditions of the type given being met or by finding the input given within the player's "Name" or "DisplayName"

Usage:
```lua
-- Finding a specific player in the game via part of their Name/DisplayName
local Player = Players:Find("Player", "inp")

-- Finding the closest player in the game
local Player, Distance = Players:Find("Closest")

-- Finding the farthest player in the game
local Player, Distance = Players:Find("Farthest")

-- Finding the newest player in the game
local Player, Age = Players:Find("Newest")

-- Finding the oldest player in the game
local Player, Age = Players:Find("Oldest")
```
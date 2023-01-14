# Utility Documentation
##### `no <>` = Necessary, `<>` = Optional

### 1) `Utility:Create(Name: string, <Parent>: Instance, <Properties>: table)`
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
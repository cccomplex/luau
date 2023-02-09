local Players = {
    Player = game:GetService("Players").LocalPlayer
}

function Players:Get(Type)
    local Types = {
        ["All"] = function()
            return game:GetService("Players"):GetPlayers()
        end,
        ["Others"] = function()
            local Output = {}

            for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                if Player ~= self.Player then
                    Output[table.getn(Output) + 1] = Player
                end
            end

            return Output
        end,
        ["Friends"] = function()
            local Output = {}

            for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                if Player:IsFriendsWith(self.Player.UserId) then
                    Output[table.getn(Output) + 1] = Player
                end
            end

            return Output
        end,
        ["Non-Friends"] = function()
            local Output = {}

            for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                if not Player:IsFriendsWith(self.Player.UserId) and Player ~= self then
                    Output[table.getn(Output) + 1] = Player
                end
            end

            return Output
        end,
        ["Team"] = function()
            local Output = {}

            for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                if Player.TeamColor == self.Player.TeamColor then
                    Output[table.getn(Output) + 1] = Player
                end
            end

            return Output
        end,
        ["Non-Team"] = function()
            local Output = {}

            for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                if not (Player.TeamColor == self.Player.TeamColor) then
                    Output[table.getn(Output) + 1] = Player
                end
            end
            
            return Output
        end,
    }
    
    if Type then
        for ReturnType, Callback in next, Types do
            if Type:lower() == ReturnType:gsub("%-", ""):lower() then
                return Callback()
            end
        end
    else
        return Types["All"]()
    end
end

function Players:Find(Type, Input)
    local Types = {
        ["Player"] = function()
            if Input then
                for _, Player in ipairs(self:Get("All")) do
                    if Player ~= self.Player then
                        local Name, DisplayName = Player.Name:lower(), Player.DisplayName:lower()
                        Input = Input:lower()
            
                        if Name:find(Input) or DisplayName:find(Input) then
                            return Player
                        end
                    end 
                end
            end
        end,
        ["Closest"] = function()
            local Distance = math.huge
            local Target = nil

            for _, Player in ipairs(self:Get("All")) do
                if Player ~= self.Player then
                    if Player ~= nil then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
    
                        if Character ~= nil then
                            local Root = Character:FindFirstChild("HumanoidRootPart")
    
                            if Root ~= nil then
                                local CCharacter = self.Player.Character or self.Player.CharacterAdded:Wait()
                                local CRoot = CCharacter:FindFirstChild("HumanoidRootPart")
    
                                if (CRoot.Position - Root.Position).magnitude < Distance then
                                    Distance = (CRoot.Position - Root.Position).magnitude
                                    Target = Player
                                end
                            end
                        end
                    end
                end
            end

            return Target
        end,
        ["Farthest"] = function()
            local Distance = 0
            local Target = nil

            for _, Player in ipairs(self:Get("All")) do
                if Player ~= self.Player then
                    if Player ~= nil then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
    
                        if Character ~= nil then
                            local Root = Character:FindFirstChild("HumanoidRootPart")
    
                            if Root ~= nil then
                                local CCharacter = self.Player.Character or self.Player.CharacterAdded:Wait()
                                local CRoot = CCharacter:FindFirstChild("HumanoidRootPart")
    
                                if (CRoot.Position - Root.Position).magnitude > Distance then
                                    Distance = (CRoot.Position - Root.Position).magnitude
                                    Target = Player
                                end
                            end
                        end
                    end
                end
            end

            return Target
        end,
        ["Newest"] = function()
            local Age = math.huge
            local Target = nil

            for _, Player in ipairs(self:Get("All")) do
                if Player ~= self.Player then
                    if Player.AccountAge < Age then
                        Age = Player.AccountAge
                        Target = Player    
                    end
                end
            end

            return Target
        end,
        ["Oldest"] = function()
            local Age = 0
            local Target = nil

            for _, Player in ipairs(self:Get("All")) do
                if Player ~= self.Player then
                    if Player.AccountAge > Age then
                        Age = Player.AccountAge
                        Target = Player    
                    end
                end
            end

            return Target
        end
    }

    if Type then
        for ReturnType, Callback in next, Types do
            if Type:lower() == ReturnType:gsub("%-", ""):lower() then
                return Callback()
            end
        end
    end
end

return Players
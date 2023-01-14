local Utility = {}

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

return Utility
function rndItem(table)
    if table == nil then return nil end
    return table[rnd(#table)]
end

function rndSelector(table)
    return function()
        return rndItem(table)
    end
end

function inList(item, list)
    for ind, val in ipairs(list) do
        if val == item then
            return true
        end
    end
    
    return false
end

function rndExcept(max, exceptions)
    local res = 0
    repeat
        res = rnd(max)
    until not inList(res, exceptions)
    
    return res
end

function updateStat(statTable)
    local res = 0
    for key, value in pairs(statTable) do
        if value == true then 
            res = res + 1
        end
    end
    
    statTable.count = res
end
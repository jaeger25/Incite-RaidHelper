function SplitString(inputstr, sep)
    if (sep == nil)
    then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)")
    do
        table.insert(t, str)
    end
    return t
end

function JoinString(stringParts, delimiter)
    return table.concat(stringParts, delimiter)
end
local DbmInterop = {}
_G["DbmInterop"] = DbmInterop

local DetailsInterop = {}
_G["DetailsInterop"] = DetailsInterop

function DbmInterop:GetVersion()
    if DBM == nil
    then
        return "0"
    else
        return DBM.DisplayVersion
    end
end

function DetailsInterop:GetVersion()
    if _detalhes == nil
    then
        return "0"
    else
        return _detalhes.userversion
    end
end

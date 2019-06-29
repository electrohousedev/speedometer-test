local M = {}
local function load_table_from_table( table )
    local idx = 1
    return function()
        local r = table[idx]
        idx = idx + 1
        return r
    end
end
function M.loadTable( file , mt, ctx)
	local data = ctx or {}
    if mt then
        setmetatable(data,mt)
    end
    local f,e 
    if type(file) == 'function' then
        f,e = load(file,'source',"bt",data)
    elseif type(file) == 'table' then
        f,e = load(load_table_from_table(file),'source',"bt",data)
    elseif type(file) == 'string' then
        f,e = loadfile(file,"bt",data)
    else
        error('need source')
    end
    if not f then error(e, 2) end
    if type(f) ~= "function" then
    	error("expected function, got " .. type(f) .. "(" .. tostring(f) .. ")" ,2)
    end
    local d = f()
    if mt then
        setmetatable(data,nil)
    end
    if d ~= nil then
    	for k,v in pairs(d) do
    		data[k]=v
    	end
    end
    return data
end

local function load_impl( file )
    local data = {}
    local f,e = loadfile(file,"bt",data)
    if not f then return nil,e end
    if type(f) ~= "function" then
        return nil,"expected function, got " .. type(f) .. "(" .. tostring(f) .. ")" 
    end
    local d = f()
    if d ~= nil then
        for k,v in pairs(d) do
            data[k]=v
        end
    end
    return data
end 

function M.load_variant( file )
    local var = application.resources.ResourcesPostfix
    if var == '' then
        return assert(load_impl(file)),false
    end
    local name = assert(string.match(file,'(.+)%.lua'))
    local v = load_impl(name .. var .. '.lua')
    if v then
        return v,true
    end
    return assert(load_impl(file)),false
end

return M



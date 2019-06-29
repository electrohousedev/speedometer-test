local lt = require "utils.load_table" 
local common = require 'utils.common'
local sb = Sandbox
local M = {}


function M.loadFont( path , dir, smooth, font , premultiplied, fixups)
	if dir then
		path = dir .. "/" .. path
	end
    local data,variant = lt.load_variant(path .. ".lua")
    local tex = application.resources:GetTexture(path .. '.png',not premultiplied)
    if not tex then
        log.error('not found font texture: ' .. path)
    end
    tex.Filtered = smooth
    local hsy_ = 0
    local fnt = font or sb.BitmapFont()
    fnt:SetHeight(data.height)
    if data.description then
    	fnt:SetSize(data.description.size)
    else
    	fnt:SetSize(data.height)
    end
    if data.metrics then
    	fnt:SetBaseline(data.metrics.height-data.metrics.ascender)
    	if data.metrics.x_height then
    		fnt:SetXHeight(data.metrics.x_height)
    	end
    else
    	fnt:SetBaseline(0)
    end


    local s = 1.0
    if variant then
        s = 0.5
    end

	for i,v in ipairs(data.chars) do 
		local img = sb.Image(tex,v.x*s,v.y*s,v.w*s,v.h*s)
		local hsx = 0
		local hsy = hsy_
		if v.ox then hsx = hsx - v.ox end
		if v.oy then hsy = hsy + v.oy end
		img.Hotspot = sb.Vector2f( hsx * s,hsy* s )
		local asc = v.width * s
		--v.fwidth or ( ( table.monospace or  ) + table.extra_x )
		--local offset = vec( 0,0)
		fnt:AddGlypth( img, v.code or v.char , asc  )
	end
    if fixups then
        for fk,fv in pairs(fixups) do
            fnt:FixupChars(fk,fv)
        end
    end
    if table.kernings then
		for i,v in ipairs(data.kernings) do
			fnt:AddKerningPair(v.from,v.to,v.offset* s)
		end
	end
    return fnt
end

function M.applyFixups( font, fixup )
    
end

function M.extend_font( font, path )
   local data,variant = lt.load_variant(path .. ".lua")
   local tex = application.resources:GetTexture(path .. '.png',not premultiplied)
   if not tex then
        log.error('not found font texture: ' .. path)
   else
        tex.Filtered = smooth
   end
   local s = 1.0
   if variant then
    s = 0.5
   end
   local hsy_ = 0
   for i,v in ipairs(data.chars) do 
        local img = sb.Image(tex,v.x*s,v.y*s,v.w*s,v.h*s)
        local hsx = 0
        local hsy = hsy_
        if v.ox then hsx = hsx - v.ox end
        if v.oy then hsy = hsy + v.oy end
        img.Hotspot = sb.Vector2f( hsx * s,hsy* s )
        local asc = v.width * s
        --v.fwidth or ( ( table.monospace or  ) + table.extra_x )
        --local offset = vec( 0,0)
        font:AddCharImage(  v.code or UTF8.GetCode(v.char) , img, asc  )
    end
end

return M

local lt = require "utils.load_table"

local M = {}

local function make_image_box( img, offsets )
    local imgbox = Sandbox.ImageBox()
    imgbox.Texture = img.Texture
    imgbox:SetTextureRect(img.TextureX,img.TextureY,img.TextureW,img.TextureH)
    imgbox:SetSize(img.Width,img.Height)
    imgbox.Hotspot = img.Hotspot
    imgbox:SetOffsets(offsets[1],offsets[2],offsets[3],offsets[4])
    return imgbox
end 

function M.loadImage( config , dir, dname)
    local file = config.file
    if not file then file = dname end
    local fname = file 
    if dir then fname = dir .. "/" .. fname end
    local img = nil
    if config.rect then
        local tex = application.resources:GetTexture( fname , not config.premultiplied )
        if not tex then error( "not found texture "..fname ) end
        local r = config.rect
        img = Sandbox.Image( tex, r[1], r[2], r[3], r[4] )
    else
        img = application.resources:GetImage( fname , not config.premultiplied )
        if not img then error( "not found image "..fname ) end
    end
    if config.hotspot then
        img.Hotspot = Sandbox.Vector2f( config.hotspot[1],config.hotspot[2])
    end
    if config.smooth then
        img.Texture.Filtered = true
    end
    if config.size then
        img:SetSize( config.size[1],config.size[2] )
    end
    if config.offsets then
        img = make_image_box(img,config.offsets)
    end
    return img
end

function M.loadImagesFormat( format, from, to , options )
    local imgs = {}
    if not options then options = {} end
    for i = from,to do
        options.file = string.format(format,i)
        imgs[#imgs+1] = M.loadImage( options )
    end
    return imgs
end 

local function make_image( config, src,name)
    local tex = assert(config[1],'not found texture in ' .. src .. ' for image ' .. name)
    local rect = config.rect or {0,0,tex.Width,tex.Height}
    local img = Sandbox.Image(tex,rect[1],rect[2],rect[3],rect[4])
    if config.hotspot then
        img.Hotspot = Sandbox.Vector2f( config.hotspot[1],config.hotspot[2])
    end
    if config.size then
        img:SetSize( config.size[1],config.size[2] )
    end
    if config.offsets then
        img = make_image_box(img,config.offsets)
        if config.tile_v or config.tile_h then
            img:SetTile(config.tile_h,config.tile_v)
        end
    end
    return img
end 


local function loadAnimation( images , data )
    local res = Sandbox.AnimationData()
    local mask = data[1]
    local from = data[2]
    local to = data[3]
    local frameset = data.frameset 
    local frames = {}
    for i = from,to do
        local name = string.format(mask,i)
        local img = images[name]
        assert(img,'not found image ' .. name)
        frames[i]=img
    end
    
    local add = data.add

    if add then
        for _,v in ipairs(add) do
            local lfrom = v[2]
            local lto = v[3]
            for i = lfrom,lto do
                local name = string.format(v[1],i)
                local img = images[name]
                assert(img,'not found image ' .. name)
                frames[to+i-lfrom+1]=img
            end
            to = to + (lto-lfrom+1)
        end
    end
    
    if frameset then
        res:Reserve(#frameset)
        for _,v in ipairs(frameset) do
            res:AddFrame(frames[v])
        end
    else
        res:Reserve(to-from+1)
        for i = from,to do
            res:AddFrame(frames[i])
        end
    end
    
    if data.speed then
        res.Speed = data.speed
    end
    if data.loop_frame then
        res.LoopFrame = data.loop_frame
    end
    return res
end

function M.loadImages( dir, file )
    local src = dir.."/"..file
    local ctx = { textures = {} , images = {} , animations = {} }
    local mt = { textures = ctx.textures , images = ctx.images, animations = ctx.animations }
    function mt.load_group( name )
        return M.loadImages(dir .. '/' .. name, 'images.lua' )
    end
    function mt._textures( textures )
        for k,v in pairs(textures) do
            local file = (v[1] or k) .. '.' .. v.type
            local tex = assert(application.resources:GetTexture( 
                dir .. '/' .. file, not v.premultiplied ),
                    'failed load texture ' .. file .. ' from ' .. src)
            if v.smooth then
                tex.Filtered = true
            end
            if v.tiled then
                tex.Tiled = true
            end
            ctx.textures[k]=tex
        end
    end
    function mt._images( images )
        for k,v in pairs(images) do
            ctx.images[k]=make_image(v,src,k)
        end
    end

    function mt._animations( animations )
        for k,v in pairs(animations) do
            local anim = assert(loadAnimation(ctx.images,v))
            ctx.animations[k] = anim
        end
    end

    function mt._animation( animation )
        return assert(loadAnimation(ctx.images,animation))
    end
    
    local t = lt.loadTable(src,{__index=mt})

    if t then
        for k,v in pairs(ctx.images) do
            t[k] = v
        end
        for k,v in pairs(ctx.animations) do
            t[k] = v
        end
        return t
    else
        error('failed load ' .. src)
        return nil
    end
end

return M


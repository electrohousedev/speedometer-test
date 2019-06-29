
local li = require "utils.load_image"
local lf = require "utils.load_font"

images = li.loadImages( 'images', 'images.lua' )

local fonts_data = {
	digits = lf.loadFont('system_font_bold_italic_20' , 'fonts', true, nil , false, nil)
}
fonts = {
	
}

for k,v in pairs(fonts_data) do
	print('make font',k)
	local fnt = Sandbox.Font( v )
	fnt:AddPass( Sandbox.FontPass(v.MainData,'main'))
	fonts[k] = fnt
end
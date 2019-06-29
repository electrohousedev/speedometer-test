local common = require 'utils.common'
local clock = common.class()

function clock:_init( data )
	self._data = data
	self._root = Sandbox.Container()
	self._root.Translate = data.pos
	self._root.Scale = data.radius / 200

	local ring = common.new{
		ui.Ring(),
		Image = images.serif_sm,
		Color = '#222233',
		ROut = 210,
		RIn = 80
	}
	ring:Build(128)
	self._root:AddObject(ring)

	self:build_serifs()
	self:build_numbers()
	self:build_arrow()
end

function clock:make_serif( pos , angle, img )
	local spr = common.new{
		Sandbox.Sprite(),
		Image = img
	}
	local cont = common.new{
		Sandbox.Container(),
		Translate = pos,
		Angle = angle * math.pi / 180.0
	}
	cont:AddObject(spr)
	self._root:AddObject(cont)
end

function clock:make_number( pos , font, value )
	local cont = common.new{
		Sandbox.Container(),
		Translate = pos,
		Scale = self._data.font_scale or 1.0
	}
	local tb = common.new{
		Sandbox.Label(),
		Font = font,
		Text = value,
		Pos = {0,- font.Baseline + font.Height * 0.5},
		Align = Sandbox.FontAlign.ALIGN_CENTER,
	}
	cont:AddObject(tb)
	self._root:AddObject(cont)
end

function clock:build_serifs(  )
	local a = 0
	local zero = Sandbox.Vector2f(0,1.0)
	for i=1,self._data.num_steps do
		local v = zero:rotated(a * math.pi / 180.0 )
		local s_big = self:make_serif( v * (200 - 16), 
			a - 90, images.serif_big )
		local asmall = a + self._data.step * 0.25
		v = zero:rotated(asmall * math.pi / 180.0 )
		local s_sm1 = self:make_serif( v * (200 - 16), 
			asmall - 90, images.serif_sm )
		amid = a + self._data.step * 0.5
		v = zero:rotated(amid * math.pi / 180.0 )
		local s_mid = self:make_serif( v * (200 - 16), 
			amid - 90, images.serif_mid )
		asmall = a + self._data.step * 0.75
		v = zero:rotated(asmall * math.pi / 180.0 )
		local s_sm1 = self:make_serif( v * (200 - 16), 
			asmall - 90, images.serif_sm )
		a = a + self._data.step
	end
	local v = zero:rotated(a * math.pi / 180.0 )
	local s_big = self:make_serif( v * (200 - 16), 
			a - 90, images.serif_big )
end

function clock:build_numbers(  )
	local a = 0
	local val = 0
	local zero = Sandbox.Vector2f(0,1.0)
	for i=1,self._data.num_steps+1 do
		local v = zero:rotated(a * math.pi / 180.0 )
		self:make_number( v * (200 - 70), fonts.digits ,self._data.format(val))
		
		a = a + self._data.step
		val = val + self._data.value_step
	end
end

function clock:build_arrow(  )
	local cont = application.app:create_arrow(self._data.name)
	cont.ValueScale = (self._data.step / self._data.value_step ) * math.pi / 180
	local arrow = common.new{
		Sandbox.Sprite(),
		Image = images.arrow
	}
	local rot = Sandbox.Container()
	rot.Angle = math.pi / 2
	rot:AddObject(arrow)
	cont:AddObject(rot)
	self._root:AddObject(cont)
end

function clock:attach( container )
	container:AddObject( self._root )
end

return clock
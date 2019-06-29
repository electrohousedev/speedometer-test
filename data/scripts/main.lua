
local clock = require 'controls.clock'
local common = require 'utils.common'

local scene = {
	root = Sandbox.ContainerBlend(),
	size = { w = 800, h = 500 },
}

function scene:build(  )
	self.speedometer = clock:new{
		name = 'speedometer',
		value_step = 20, -- km/h -> deg
		pos = { 250, 250 },
		radius = 230,
		num_steps = 12,
		step = 22,
		format = function( v ) return string.format('%d',v) end
	}
	self.speedometer:attach(self.root)

	self.tachometer = clock:new{
		name = 'tachometer',
		value_step = 1000, 
		pos = { 650, 300 },
		radius = 130,
		num_steps = 10,
		step = 28,
		font_scale = 1.5,
		format = function( v ) return string.format('%d', v / 1000) end
	}
	self.tachometer:attach(self.root)

	self.root:AddObject(common.new{
		Sandbox.Label(),
		Font = fonts.digits,
		Text = 'km/h',
		Pos = {340,380}
	})

	self.root:AddObject(common.new{
		Sandbox.Label(),
		Font = fonts.digits,
		Text = 'x1000',
		Pos = {690,365}
	})

	self.root:AddObject(common.new{
		Sandbox.Label(),
		Font = fonts.digits,
		Text = 'r/min',
		Pos = {680,390}
	})

	
end

function scene:on_resize()
	local sx = application.size.width / self.size.w
	local sy = application.size.height / self.size.h
	local s = math.min(sx,sy)
	self.root.Scale = s
	self.root.Translate = { 
		(application.size.width - self.size.w * s) * 0.5,
		(application.size.height - self.size.h * s) * 0.5,
	}
end

function scene:present(  )
	application.scene:AddObject(self.root)
end

scene:build()
scene:on_resize()
scene:present()

function application.onResize()
	scene:on_resize()
end
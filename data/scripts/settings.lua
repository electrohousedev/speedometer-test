
local width = math.max( settings.width, settings.height)
local height = math.min( settings.width, settings.height )

application.app.DrawDebugInfo = true
application.app.ResizeableWindow = true

if platform.os ~= 'android' then
	width = 800
	height = 600
else
	settings.fullscreen = false
end

settings.width = width
settings.height = height

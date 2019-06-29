ProjectName = 'speedometer'
SandboxRoot = 'sandbox'

local host_dir = os.host()
if host_dir == 'macosx' then
	host_dir = 'osx'
end

UseModules = {
	
}

AndroidConfig = {
	abi = {'x86'},
	api_level = 16,
	target_api_level = 28,
	build_api_level = 28,
	build_tools_version = '28.0.3',
	toolchain='clang',
	stl = 'c++_static',
	package = 'com.test.speedometer',
	screenorientation = 'sensorLandscape',
	versioncode= 100,
	versionname='0.100',
	permissions = {},
}

function solution_config()
	cppdialect "C++11"
	xcodebuildsettings { 
		MACOSX_DEPLOYMENT_TARGET = '10.9' , 
	}
end

require 'sandbox'

files {
	'src/**.h',
	'src/**.cpp',
}

includedirs { 'src' }

android_res { path.getabsolute('projects/android/res') }

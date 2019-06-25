ProjectName = 'speedometer'
SandboxRoot = 'sandbox'

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

require 'sandbox'

files {
	'src/**.h',
	'src/**.cpp',
}

includedirs { 'src' }

android_res { path.getabsolute('projects/android/res') }

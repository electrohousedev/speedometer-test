ProjectName = 'speedometer'
SandboxRoot = 'sandbox'

local host_dir = os.host()
if host_dir == 'macosx' then
	host_dir = 'osx'
end

UseModules = {
	
}

AndroidConfig = {
	abi = {'x86','arm64-v8a','armeabi-v7a'},
	api_level = 16,
	target_api_level = 28,
	build_api_level = 28,
	build_tools_version = '28.0.3',
	toolchain='clang',
	stl = 'c++_static',
	package = 'com.test.speedometer',
	screenorientation = 'sensorLandscape',
	manifest='projects/android/AndroidManifest.xml',
	versioncode= 100,
	versionname='0.100',
	permissions = {},
	keystore='projects/android/key/test.keystore',
	keyalias='test',

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



local assets_path = path.join('projects' , platform_dir , 'assets')
os.mkdir(path.join(assets_path,'data'))
prebuildcommands { 
	path.getabsolute(path.join(SandboxRoot,'bin',host_dir,'assetsbuilder')) .. iif(os.ishost('windows'),'.exe','') ..
		' --scripts=' .. path.getabsolute(path.join(SandboxRoot,'utils','assetsbuilder','scripts')) ..
		' --src=' .. path.getabsolute('data') ..
		' --dst=' .. path.getabsolute(path.join(assets_path,'data')) ..
		' --platform=' .. platform_dir 
}


files { assets_path .. '/data' }

if os.istarget('macosx') then
	files {
		'projects/osx/Info.plist',
	}
	xcodebuildresources {
		'assets/data'
	}
elseif os.istarget('android') then
	files {
		'projects/android/csrc/**.cpp'
	}
	android_res { path.getabsolute('projects/android/res') }
	android_assets_path{
			path.getabsolute('projects/android/assets'),
		}
	android_keystore_pwd('123456')
	android_key_pwd('123456')
end
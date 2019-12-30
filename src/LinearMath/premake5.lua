	project "LinearMath"

	kind "StaticLib"

	SetPerProjectSettings()

	if os.istarget("Linux") then
	    buildoptions{"-fPIC"}
	end
	includedirs {
		"..",
	}
	files {
		"*.cpp",
		"*.h",
		"TaskScheduler/*.cpp",
		"TaskScheduler/*.h"
	}
	
	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()
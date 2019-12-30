	project "Bullet3Common"

	language "C++"
				
	kind "StaticLib"
		
	SetPerProjectSettings()

	if os.istarget("Linux") then
	    buildoptions{"-fPIC"}
	end

	includedirs {".."}

	files {
		"*.cpp",
		"*.h"
	}

	
	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()

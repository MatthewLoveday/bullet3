	project "Bullet3Collision"

	language "C++"
				
	kind "StaticLib"
		
	SetPerProjectSettings()

	includedirs {".."}

    if os.istarget("Linux") then
        buildoptions{"-fPIC"}
    end

	files {
		"**.cpp",
		"**.h"
	}

	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()

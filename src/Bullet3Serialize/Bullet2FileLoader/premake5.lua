	project "Bullet2FileLoader"
		
	kind "StaticLib"
	
	SetPerProjectSettings()

	includedirs {
		"../../../src"
	}
	
    if os.istarget("Linux") then
        buildoptions{"-fPIC"}
    end
	 
	files {
		"**.cpp",
		"**.h"
	}
	
	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()
	project "BulletInverseDynamics"

	kind "StaticLib"
	SetPerProjectSettings()

    if os.istarget("Linux") then
        buildoptions{"-fPIC"}
    end
	includedirs {
		"..",
	}
	files {
		"IDMath.cpp",
		"MultiBodyTree.cpp",
		"details/MultiBodyTreeInitCache.cpp",
		"details/MultiBodyTreeImpl.cpp",
	}
	
	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()

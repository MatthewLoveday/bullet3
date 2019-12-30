	project "BulletCollision"

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
		"BroadphaseCollision/*.cpp",
		"BroadphaseCollision/*.h",
		"CollisionDispatch/*.cpp",
                "CollisionDispatch/*.h",
		"CollisionShapes/*.cpp",
		"CollisionShapes/*.h",
		"Gimpact/*.cpp",
		"Gimpact/*.h",
		"NarrowPhaseCollision/*.cpp",
		"NarrowPhaseCollision/*.h",
	}

	SetPlatformSettingsPerProject()	
	SetConfigurationSettingsPerProject()
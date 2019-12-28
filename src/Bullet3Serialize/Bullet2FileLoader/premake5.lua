	project "Bullet2FileLoader"
		
	kind "StaticLib"
	
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
	
	filter "system:windows"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

	filter "system:linux"
		pic "On"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"
function createProject(vendor)
	hasCL = findOpenCL(vendor)
	
	if (hasCL) then
		
		project ("Bullet3OpenCL_" .. vendor)
	
		initOpenCL(vendor)
			
		kind "StaticLib"
		
        if os.istarget("Linux") then
            buildoptions{"-fPIC"}
        end
		
		includedirs {
			".",".."
		}
		
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
	end
end

createProject("clew")
createProject("AMD")
createProject("Intel")
createProject("NVIDIA")
createProject("Apple")

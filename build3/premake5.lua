
local osversion = os.getversion()

projectRootDir = os.getcwd() .. "/../"

print(string.format(" %d.%d.%d (%s)",
	osversion.majorversion, osversion.minorversion, osversion.revision,
	osversion.description))

if _ACTION == "vs2019" or _ACTION=="vs2010" then
	buildoptions
	{
		-- Disable a few useless warnings
		"/wd4244",
		"/wd4267"
	}
end

staticruntime "On"

act = ""

if _ACTION then
	act = _ACTION
end


---------------------------------------------------------------------------------------------------------------------------------  OPTIONS
newoption 
{
	trigger     = "ios",
	description = "Enable iOS target (requires xcode4)"
}

newoption
{
	trigger = "enable_system_glx",
	description = "Try to link against system glx instead of using glad_glx (default)"
}

newoption
{
	trigger = "enable_openvr",
	description = "Enable experimental Virtual Reality examples, using OpenVR for HTC Vive and Oculus Rift"
}

newoption
{
	trigger = "enable_system_opengl",
	description = "Try to link and use the system OpenGL headers version instead of dynamically loading OpenGL (dlopen is default)"
}

newoption
{
	trigger = "enable_system_x11",
	description = "Try to link and use system X11 headers instead of dynamically loading X11 (dlopen is default)"
}

newoption
{
	trigger = "enable_stable_pd",
	description = "Enable Stable PD control in PyBullet"
}

newoption
{
	trigger = "enable_static_vr_plugin",
	description = "Statically link vr plugin (in examples/SharedMemory/plugins/vrSyncPlugin)"
}

newoption
{
	trigger = "enable_physx",
	description = "Allow optional PhysX backend for PyBullet, use pybullet.connect(pybullet.PhysX)."
}

newoption
{
	trigger = "noopengl3",
	description = "Don't compile any OpenGL3+ code"
}

newoption
{
	trigger = "midi",
	description = "Use Midi controller to control parameters"
}

------------------------------------------------------------------------------------------------------------------------------------- BEGIN GRPC

if os.istarget("Linux") then
	default_grpc_include_dir = "usr/local/include/GRPC"
	default_grpc_lib_dir = "/usr/local/lib"
	default_protobuf_include_dir = "/usr/local/include/protobuf"
	default_protobuf_lib_dir = "/usr/local/lib"
end

if os.istarget("macosx") then
	default_grpc_include_dir = "/usr/local/Cellar/grpc/1.14.1/include"
	default_grpc_lib_dir = "/usr/local/Cellar/grpc/1.14.1/lib"
					default_protobuf_include_dir = "/usr/local/Cellar/protobuf/3.6.0/include"
	default_protobuf_lib_dir = "/usr/local/Cellar/protobuf/3.6.0/lib"
end

if os.istarget("Windows") then
	default_grpc_include_dir = projectRootDir .. "examples/ThirdPartyLibs/grpc/include"
	default_grpc_lib_dir = projectRootDir .. "examples/ThirdPartyLibs/grpc/lib"
	default_protobuf_include_dir =projectRootDir .. "examples/ThirdPartyLibs/grpc/include"
	default_protobuf_lib_dir = projectRootDir .. "examples/ThirdPartyLibs/grpc/lib"
end

newoption
{
					trigger     = "grpc_include_dir",
					value       = default_grpc_include_dir,
					description = "(optional) GRPC include directory"
}

newoption
{
					trigger     = "grpc_lib_dir",
					value       = default_grpc_lib_dir,
					description = "(optional) GRPC library directory "
}


newoption
{
				trigger     = "protobuf_include_dir",
				value       = default_protobuf_include_dir,
				description = "(optional) protobuf include directory"
}

newoption
{
				trigger     = "protobuf_lib_dir",
				value       = default_protobuf_lib_dir,
				description = "(optional) protobuf library directory "
}

if not _OPTIONS["grpc_lib_dir"] then
	_OPTIONS["grpc_lib_dir"] = default_grpc_lib_dir
end
if not _OPTIONS["grpc_include_dir"] then
	_OPTIONS["grpc_include_dir"] = default_grpc_include_dir
end

if _OPTIONS["enable_grpc"] then
	function initGRPC()
			print "BT_ENABLE_GRPC"

			print("grpc_include_dir=")
			print(_OPTIONS["grpc_include_dir"])
			print("grpc_lib_dir=")
			print(_OPTIONS["grpc_lib_dir"])
			print("protobuf_include_dir=")
			print(_OPTIONS["protobuf_include_dir"])
			print("protobuf_lib_dir=")
			print(_OPTIONS["protobuf_lib_dir"])
			
			defines {"BT_ENABLE_GRPC"}
			
			if os.istarget("macosx") then
			 buildoptions { "-std=c++11" }
			 links{ "dl"}
			end
			
			if os.istarget("Linux") then
			 		buildoptions { "-std=c++11" }
					links{ "dl"}
			end
			
			if os.istarget("Windows") then
					defines {"_WIN32_WINNT=0x0600"}
					links{ "zlibstatic","ssl","crypto"}
			end

      includedirs {
             projectRootDir .. "examples", _OPTIONS["grpc_include_dir"], _OPTIONS["protobuf_include_dir"],
      }

			if os.istarget("Windows") then
				configuration {"x64", "debug"}			
						libdirs {_OPTIONS["grpc_lib_dir"] .. "/win64_debug" , _OPTIONS["protobuf_lib_dir"] .. "win64_debug",}
				configuration {"x86", "debug"}
						libdirs {_OPTIONS["grpc_lib_dir"] .. "/win32_debug" , _OPTIONS["protobuf_lib_dir"] .. "win32_debug",}
				configuration {"x64", "release"}
						libdirs {_OPTIONS["grpc_lib_dir"] .. "/win64_release", _OPTIONS["protobuf_lib_dir"] .. "win64_release",}
				configuration {"x86", "release"}
						libdirs {_OPTIONS["grpc_lib_dir"] .. "/win32_release" , _OPTIONS["protobuf_lib_dir"] .. "win32_release",}
				configuration{}
				
				else
				libdirs {_OPTIONS["grpc_lib_dir"], _OPTIONS["protobuf_lib_dir"],}
			end
      
      links { "grpc","grpc++", "grpc++_reflection", "gpr", "protobuf"}
      files { 
      projectRootDir .. "examples/SharedMemory/grpc/ConvertGRPCBullet.cpp",
			projectRootDir .. "examples/SharedMemory/grpc/ConvertGRPCBullet.h",
			projectRootDir .. "examples/SharedMemory/grpc/proto/pybullet.grpc.pb.cpp",
			projectRootDir .. "examples/SharedMemory/grpc/proto/pybullet.grpc.pb.h",
			projectRootDir .. "examples/SharedMemory/grpc/proto/pybullet.pb.cpp",
			projectRootDir .. "examples/SharedMemory/grpc/proto/pybullet.pb.h", }
	end
end

------------------------------------------------------------------------------------------------------------------------------------- END GRPC

------------------------------------------------------------------------------------------------------------------------------------- BEGIN PROTOBUF

if not _OPTIONS["protobuf_include_dir"] then
	_OPTIONS["protobuf_include_dir"] = default_protobuf_include_dir
end	

if not _OPTIONS["protobuf_lib_dir"] then
	_OPTIONS["protobuf_lib_dir"] = default_protobuf_lib_dir
end	

------------------------------------------------------------------------------------------------------------------------------------- END PROTOBUF

------------------------------------------------------------------------------------------------------------------------------------- BEGIN EGL
newoption
{
	trigger = "enable_egl",
	value       = false,
	description = "Build an experimental eglPlugin"
}

if _OPTIONS["enable_egl"] then
	function initEGL()
		defines {"BT_USE_EGL"}
	end
end	

------------------------------------------------------------------------------------------------------------------------------------- END EGL


------------------------------------------------------------------------------------------------------------------------------------- DEMOS, EXTRAS, EXAMPLES
newoption
{
	trigger = "demos",
	description = "Build demos"
}

newoption
{
	trigger = "extras",
	description = "Build Extras"
}

newoption
{
	trigger = "standalone-examples",
	description = "Build standalone examples with reduced dependencies."
}

newoption
{
	trigger = "test",
	description = "Enable all tests"
}

newoption
{
	trigger = "gtest",
	description = "Enable unit tests using gtest"
}

newoption
{
	trigger = "no-bullet3",
	description = "Do not build bullet3 libs"
}

------------------------------------------------------------------------------------------------------------------------------------- END DEMOS, EXTRAS, EXAMPLES



------------------------------------------------------------------------------------------------------------------------------------- CLSOCKET, ENET, LUA

newoption
{
	trigger = "clsocket",
	description = "Enable clsocket and clsocket tests (used for optional TCP networking in pybullet and shared memory C-API)"
}


newoption
{
	trigger = "enet",
	description = "Enable enet and enet tests (used for optional UDP networking in pybullet and shared memory C-API)"
}

newoption
{
	trigger = "lua",
	description = "Enable Lua scipting support in Example Browser"
}

------------------------------------------------------------------------------------------------------------------------------------- END CLSOCKET, ENET, LUA


------------------------------------------------------------------------------------------------------------------------------------- PyBullet
newoption
{
		trigger = "enable_pybullet",
		description = "Enable high-level Python scripting of Bullet with URDF/SDF import and synthetic camera."
}

if os.istarget("Linux") then
	default_python_include_dir = "/usr/include/python2.7"
	default_python_lib_dir = "/usr/local/lib/"
end

   
if os.istarget("Windows") then
	default_python_include_dir = "C:/Python-3.5.2/include"
	default_python_lib_dir = "C:/Python-3.5.2/libs"
end

newoption
{
		trigger     = "python_include_dir",
		value       = default_python_include_dir,
		description = "Python (2.x or 3.x) include directory"
}

newoption
{
		trigger     = "python_lib_dir",
		value       = default_python_lib_dir,
		description = "Python (2.x or 3.x) library directory "
}


------------------------------------------------------------------------------------------------------------------------------------- END PyBullet

newoption
{
	trigger = "serial",
	description = "Enable serial, for testing the VR glove in C++"
}

newoption
{
	trigger = "double",
	description = "Double precision version of Bullet"
}

newoption
{
	trigger = "enable_multithreading",
	description = "enable CPU multithreading for bullet3 libs"
}



newoption 
{
	trigger     = "targetdir",
	value       = "path such as ../bin",
	description = "Set the output location for the generated project files"
}

newoption
{
	trigger = "audio",
	description = "Enable audio"
}

---------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------- XCODE SETTINGS

if _ACTION == "xcode4" then
	if _OPTIONS["ios"] then
		_OPTIONS["no-bullet3"] = "1"
		_OPTIONS["gtest"] = "0"

		postfix = "ios";
		xcodebuildsettings
		{
			'INFOPLIST_FILE = "../../test/Bullet2/Info.plist"',
			'CODE_SIGN_IDENTITY = "iPhone Developer"',
			"SDKROOT = iphoneos",
			'ARCHS = "armv7"',
			'TARGETED_DEVICE_FAMILY = "1,2"',
			'VALID_ARCHS = "armv7"',
		}
	else
		xcodebuildsettings
		{
			'ARCHS = "$(ARCHS_STANDARD_64_BIT)"',
			'VALID_ARCHS = "x86_64"',
--			'SDKROOT = "macosx10.9"',
		}
	end
end

--------------------------------------------------------------------------------------------------------------------------------- END XCODE SETTINGS



--------------------------------------------------------------------------------------------------------------------------------- SETUP DEFAULT DIRECTORIES

if not _OPTIONS["python_include_dir"] then
	_OPTIONS["python_include_dir"] = default_python_include_dir
end

if not _OPTIONS["python_lib_dir"] then
	_OPTIONS["python_lib_dir"] = default_python_lib_dir
end

if os.istarget("Linux") then
		default_glfw_include_dir = "usr/local/include/GLFW"
		default_glfw_lib_dir = "/usr/local/lib/"
default_glfw_lib_name = "glfw3"
end

if os.istarget("macosx") then
default_glfw_include_dir = "/usr/local/Cellar/glfw/3.2.1/include"
default_glfw_lib_dir = "/usr/local/Cellar/glfw/3.2.1/lib"
default_glfw_lib_name = "glfw"
end

if os.istarget("Windows") then
		default_glfw_include_dir = "c:/glfw/include"
		default_glfw_lib_dir = "c:/glfw/lib"
default_glfw_lib_name = "glfw3"
end



if not _OPTIONS["glfw_lib_dir"] then
_OPTIONS["glfw_lib_dir"] = default_glfw_lib_dir
end
if not _OPTIONS["glfw_include_dir"] then
_OPTIONS["glfw_include_dir"] = default_glfw_include_dir
end
if not _OPTIONS["glfw_lib_name"] then
_OPTIONS["glfw_lib_name"] = default_glfw_lib_name
end	

newoption
{
		trigger     = "glfw_include_dir",
		value       = default_glfw_include_dir,
		description = "GLFW 3.x include directory"
}

 newoption
{
					trigger     = "glfw_lib_name",
					value       = default_glfw_lib_name,
					description = "GLFW 3.x library name (glfw, glfw3)"
}

newoption
{
		trigger     = "glfw_lib_dir",
		value       = default_glfw_lib_dir,
		description = "(optional) GLFW 3.x library directory "
}

newoption
{
		trigger     = "enable_glfw",
		value       = false,
		description = "(optional) use GLFW 3.x library"
}


if _OPTIONS["enable_glfw"] then
	defines {"B3_USE_GLFW"}
	
	function initOpenGL()
	includedirs {
				projectRootDir .. "examples/ThirdPartyLibs/glad"
		}
	
		includedirs {
			_OPTIONS["glfw_include_dir"],
		}
		
		libdirs {
			_OPTIONS["glfw_lib_dir"]
		}
		links { _OPTIONS["glfw_lib_name"]}
		files { projectRootDir .. "examples/ThirdPartyLibs/glad/glad.c" }
	end
	function findOpenGL3()
		return true
	end
	function initGlew()
	end
	function initX11()
	links {"X11", "dl","pthread"}

	end
	
else
	dofile ("findOpenGLGlewGlut.lua")
	if (not findOpenGL3()) then
		defines {"NO_OPENGL3"}
	end
end

--------------------------------------------------------------------------------------------------------------------------------- END SETUP DEFAULT DIRECTORIES




function SetConfigurationSettingsPerProject()

	filter "configurations:Debug"
		defines {"_DEBUG=1"}
		flags { "NoMinimalRebuild"}
		symbols "on"
		staticruntime "on"
		floatingpoint "fast"
		runtime "debug"

	filter "configurations:Release"
		flags { "NoMinimalRebuild"}
		vectorextensions "SSE2"
		staticruntime "on"
		optimize "on"
		floatingpoint "fast"
		runtime "release"


	filter "configurations:Distribution"
		flags { "NoMinimalRebuild"}
		vectorextensions "SSE2"
		optimize "on"
		staticruntime "on"
		floatingpoint "fast"
		editandcontinue "off"
		runtime "release"
end

function SetPlatformSettingsPerProject()

	filter "system:windows"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

	filter "system:linux"
		pic "On"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

end


--Going to be used across threads
if _OPTIONS["enable_multithreading"] then
	defines {"BT_THREADSAFE=1"}
end

--Use Doubles instead of floats
if _OPTIONS["double"] then
	defines {"BT_USE_DOUBLE_PRECISION"}
end

--If using audio then include tiny audio
if _OPTIONS["audio"] then
	include "../examples/TinyAudio"
end

--If using serial then include serial
if _OPTIONS["serial"] then
	include "../examples/ThirdPartyLibs/serial"
end


--If the demos option is set then build the demos
if _OPTIONS["demos"] then
	include "../examples/ExampleBrowser"
	include "../examples/RobotSimulator"
	include "../examples/OpenGLWindow"
	include "../examples/ThirdPartyLibs/Gwen"
	include "../examples/HelloWorld"
	include "../examples/SharedMemory"
	include "../examples/ThirdPartyLibs/BussIK"

	if _OPTIONS["lua"] then
	   include "../examples/ThirdPartyLibs/lua-5.2.3"
	end
	if _OPTIONS["enable_pybullet"] then
	  include "../examples/pybullet"
	end
	include "../examples/SimpleOpenGL3"

	if _OPTIONS["standalone-examples"] then
		
		include "../examples/TinyRenderer"
		include "../examples/BasicDemo"
		include "../examples/InverseDynamics"
		include "../examples/ExtendedTutorials"
		include "../examples/MultiThreading"
	end

	--if doing tests then include tests
	if _OPTIONS["test"] then
		include "../test/SharedMemory"
	end
end


--if using midi audio then build midi
if _OPTIONS["midi"] then
	include "../examples/ThirdPartyLibs/midi"
end


--If using clsocket then build clsocket
if _OPTIONS["clsocket"] then
	defines {"BT_ENABLE_CLSOCKET"}
	include "../examples/ThirdPartyLibs/clsocket"		
	include "../test/clsocket"
end

--if using enet then build enet
if _OPTIONS["enet"] then
	defines {"BT_ENABLE_ENET"}

	include "../examples/ThirdPartyLibs/enet"
	include "../test/enet/nat_punchthrough/client"
	include "../test/enet/nat_punchthrough/server"
	include "../test/enet/chat/client"
	include "../test/enet/chat/server"
end


--if no extras then disable demos too
if not _OPTIONS["extras"] then
	--print "--no-extras implies --no-demos"
	_OPTIONS["demos"] = "0"
else
	--else include extras
	include "../Extras"
end


--if testing then include tests
if _OPTIONS["test"] then
	include "../test/Bullet2"

	if _OPTIONS["gtest"] then
		include "../test/gtest-1.7.0"
--			include "../test/hello_gtest"
		include "../test/collision"
		include "../test/BulletDynamics/pendulum"
		if not _OPTIONS["no-bullet3"] then
			if _OPTIONS["extras"] then
				include "../test/InverseDynamics"
			end
			include "../test/TestBullet3OpenCL"
		end
		if _OPTIONS["demos"] then
			-- Gwen is only used for demos
			include "../test/GwenOpenGLTest"
		end
	end
end









--CORE PROJECT INCLUDES


	dofile ("findOpenCL.lua")
	dofile ("findDirectX11.lua")

if _OPTIONS["no-bullet3"] then
		print "--no-bullet3 implies --no-demos"
		_OPTIONS["demos"] = "0"
else
	--project includes
	include "../src/Bullet3Common"
	include "../src/Bullet3Geometry"
	include "../src/Bullet3Collision"
	include "../src/Bullet3Dynamics"
	include "../src/Bullet3OpenCL"
	include "../src/Bullet3Serialize/Bullet2FileLoader"
	include "../src/BulletInverseDynamics"
	include "../src/BulletSoftBody"
	include "../src/BulletDynamics"
	include "../src/BulletCollision"
	include "../src/LinearMath"
end

--If Physx flag exists, enable physx
if _OPTIONS["enable_physx"] then
	include "../src/physx"
end

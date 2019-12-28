
local osversion = os.getversion()

projectRootDir = os.getcwd() .. "/../"

print(string.format(" %d.%d.%d (%s)",
	osversion.majorversion, osversion.minorversion, osversion.revision,
	osversion.description))

if _ACTION == "vs2019" or _ACTION=="vs2010" then
	buildoptions
	{
		-- Multithreaded compiling
		"/MP",
		-- Disable a few useless warnings
		"/wd4244",
		"/wd4267"
	}
end

act = ""

if _ACTION then
	act = _ACTION
end

newoption {
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
	trigger = "enable_system_opengl",
	description = "Try to link and use the system OpenGL headers version instead of dynamically loading OpenGL (dlopen is default)"
}

newoption
{
	trigger = "enable_openvr",
	description = "Enable experimental Virtual Reality examples, using OpenVR for HTC Vive and Oculus Rift"
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
	trigger = "no-extras",
	description = "Don't build Extras"
}

if os.is("Linux") then
		default_python_include_dir = "/usr/include/python2.7"
		default_python_lib_dir = "/usr/local/lib/"
end

		
if os.is("Windows") then
		default_python_include_dir = "C:/Python-3.5.2/include"
		default_python_lib_dir = "C:/Python-3.5.2/libs"
end

newoption
{
	trigger = "double",
	description = "Double precision version of Bullet"
}

newoption
{
	trigger = "enable_multithreading",
	description = "enable CPU multithreading for bullet2 libs"
}

--Going to be used across threads
if _OPTIONS["enable_multithreading"] then
	defines {"BT_THREADSAFE=1"}
end

--Use Doubles instead of floats
if _OPTIONS["double"] then
	defines {"BT_USE_DOUBLE_PRECISION"}
end

if os.is("Linux") then
	default_glfw_include_dir = "usr/local/include/GLFW"
	default_glfw_lib_dir = "/usr/local/lib/"
	default_glfw_lib_name = "glfw3"
end

if os.is("macosx") then
	default_glfw_include_dir = "/usr/local/Cellar/glfw/3.2.1/include"
	default_glfw_lib_dir = "/usr/local/Cellar/glfw/3.2.1/lib"
	default_glfw_lib_name = "glfw"
end

if os.is("Windows") then
	default_glfw_include_dir = "c:/glfw/include"
	default_glfw_lib_dir = "c:/glfw/lib"
	default_glfw_lib_name = "glfw3"
end


	dofile ("findOpenCL.lua")
	dofile ("findDirectX11.lua")

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

--If Physx flag exists, enable physx
if _OPTIONS["enable_physx"] then
	include "../src/physx"
end

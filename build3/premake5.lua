
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
	trigger = "enable_system_x11",
	description = "Try to link and use system X11 headers instead of dynamically loading X11 (dlopen is default)"
}

newoption
{
	trigger = "enable_physx",
	description = "Allow optional PhysX backend for PyBullet, use pybullet.connect(pybullet.PhysX)."
}

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

	dofile ("findOpenCL.lua")
	dofile ("findDirectX11.lua")

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

--If Physx flag exists, enable physx
if _OPTIONS["enable_physx"] then
	include "../src/physx"
end

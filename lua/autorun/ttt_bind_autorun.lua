-- Clientside bind lib
if SERVER then
	AddCSLuaFile("bind/cl_init.lua")
else
	include("bind/cl_init.lua")
end

local loadingUrl = GetConVar("sv_loadingurl")

if loadingUrl and loadingUrl:GetString() == "" then
	game.ConsoleCommand("sv_loadingurl \"asset://garrysmod/materials/vgui/ttt/loadingscreen/loading.vtf\"\n")
end

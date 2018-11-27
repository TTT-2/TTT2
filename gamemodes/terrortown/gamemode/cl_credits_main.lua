local creditHTML = "<center><h1>TTT2 CREDITS</h1></center><br><br>"
local credits = {
	[1] = {
		name = "Developer",
		users = {
			["Alf21"] = "https://steamcommunity.com/id/alf21",
			["SchokoShampoo"] = "https://steamcommunity.com/id/schokoshampoo"
		}
	},
	[2] = {
		name = "Designer",
		users = {
			["Mineotopia"] = "https://steamcommunity.com/id/mineotopia"
		}
	},
	[3] = {
		name = "Bug Reporter #1",
		users = {
			["dok441"] = "https://steamcommunity.com/id/spylony/"
		}
	},
	[4] = {
		name = "Bug Reporter #2",
		users = {
			["Avalon"] = "https://steamcommunity.com/id/NoAvalon"
		}
	},
	[5] = {
		name = "Bug Reporter #3",
		users = {
			["Pekusuii | Shu"] = "https://steamcommunity.com/profiles/76561198066951681/"
		}
	},
	[6] = {
		name = "BETA Tester",
		users = {
			["Kanjuro"] = "https://steamcommunity.com/id/Siques",
			["Remph"] = "https://steamcommunity.com/id/remphnick",
			["Desteny"] = "https://steamcommunity.com/profiles/76561198119065689",
			["CelleYTV"] = "https://steamcommunity.com/profiles/76561198077207352",
			["Trystan"] = "https://steamcommunity.com/id/bailbondsh"
		}
	}
}

local creditPanel

for _, creditGroup in ipairs(credits) do
	creditHTML = creditHTML .. "<p><h1>" .. creditGroup.name .. "</h1><ul>"

	for name, link in pairs(creditGroup.users) do
		creditHTML = creditHTML .. "<li><a href='" .. link .. "'>" .. name .. "</a></li>"
	end

	creditHTML = creditHTML .. "</ul></p>"
end

function GetTTT2Credits()
	return credits
end

function GetTTT2CreditsHTML()
	return creditHTML
end

function ShowCredits()
	if IsValid(creditPanel) then
		creditPanel:Remove()

		return
	end

	local w = ScrW() - 50

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, ScrH() - 50)
	frame:SetTitle("TTT2 Credits")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:Center()

	--Fill the form with a html page
	local html = vgui.Create("DHTML", frame)
	html:Dock(FILL)
	html:SetHTML(GetTTT2CreditsHTML())
	html:DockMargin(0, 31, 0, 0)

	local ctrls = vgui.Create("DHTMLControls", frame) -- Navigation controls
	ctrls:SetWide(w)
	ctrls:SetPos(0, 23)
	ctrls:SetHTML(html) -- Links the controls to the DHTML window

	frame:MakePopup()

	creditPanel = frame
end

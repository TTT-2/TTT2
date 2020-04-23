local materialIcon = Material("vgui/ttt/vskin/helpscreen/changelog")

local htmlStart = [[
	<head>
		<style>
			body {
				font-family: Trebuchet, Verdana;
				background-color: rgb(22, 42, 57);
				color: white;
				font-weight: 100;
			}
			body * {
				font-size: 13pt;
			}
			h1 {
				font-size: 16pt;
				text-decoration: underline;
			}
		</style>
	</head>
	<body>
]]

local htmlEnd = [[
	</body>
]]

HELPSCRN.populate["ttt2_changelog"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_changelog_title")
	bindingsData:SetDescription("menu_changelog_description")
	bindingsData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_changelog"] = function(helpData, id)
	local changelog = GetSortedChanges()

	for i = 1, #changelog do
		local change = changelog[i]

		local changelogData = helpData:PopulateSubMenu(id .. "_" .. tostring(i))

		changelogData:SetTitle(change.version)
		changelogData:PopulatePanel(function(parent)
			local header = "<h1>" .. change.version .. " Update"

			if change.date > 0 then
				header = header .. " <i> - (date: " .. os.date("%Y/%m/%d", change.date) .. ")</i>"
			end

			header = header .. "</h1>"

			local html = vgui.Create("DHTML", parent)
			html:SetSize(500, 500)
			html:Dock(FILL)
			html:SetHTML(htmlStart .. header .. change.text .. htmlEnd)
		end)
	end
end

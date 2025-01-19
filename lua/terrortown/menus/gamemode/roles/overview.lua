--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_roles_overview_title"
CLGAMEMODESUBMENU.searchable = false

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

local TryT = LANG.TryTranslation

function CLGAMEMODESUBMENU:Populate(parent)
    local html = vgui.Create("DHTML", parent)
    html:SetSize(500, 640)
    html:Dock(FILL)
    html:SetHTML(htmlStart .. TryT("roles_overview_html") .. htmlEnd)
end

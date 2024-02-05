--- @ignore

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

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
    local header = "<h1>" .. self.change.version .. " Update"

    if self.change.date > 0 then
        header = header .. " <i> - (date: " .. os.date("%Y/%m/%d", self.change.date) .. ")</i>"
    end

    header = header .. "</h1>"

    local html = vgui.Create("DHTML", parent)
    html:SetSize(500, 640)
    html:Dock(FILL)
    html:SetHTML(htmlStart .. header .. self.change.text .. htmlEnd)
end

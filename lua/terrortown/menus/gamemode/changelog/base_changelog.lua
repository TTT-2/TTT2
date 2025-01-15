--- @ignore

local htmlStart = [[
    <head>
        <style>
            body {
                font-family: Trebuchet, Verdana;
                background-color: rgb(22, 42, 57);
                color: white;
                font-weight: 100;
                --ui-scale: /*TTT2-UISCALE*/;
            }
            body * {
                font-size: calc(13pt * var(--ui-scale));
            }
            h1 {
                font-size: calc(16pt * var(--ui-scale));
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
    local scale = appearance.GetGlobalScale()
    html:SetSize(500 * scale, 640 * scale)
    html:Dock(FILL)
    html:SetHTML(
        string.Replace(htmlStart, "/*TTT2-UISCALE*/", tostring(scale))
            .. header
            .. self.change.text
            .. htmlEnd
    )
end

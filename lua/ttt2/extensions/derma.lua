---
-- derma extensions
-- @author Mineotopia
-- @module derma

if SERVER then
    AddCSLuaFile()

    fileloader.LoadFolder("terrortown/derma/modules/", false, CLIENT_FILE)

    fileloader.LoadFolder("terrortown/derma/core/", false, CLIENT_FILE)
    fileloader.LoadFolder("terrortown/derma/variants/", false, CLIENT_FILE)
    fileloader.LoadFolder("terrortown/derma/menus/", false, CLIENT_FILE)
    fileloader.LoadFolder("terrortown/derma/menus/elements/", false, CLIENT_FILE)

    return
end

local basePanels = {}

local function BuildPanel(panel, path, name)
    -- DERMA INFO TABLE CONTAINS REGISTRATION DATA
    local dermaInfo = table.Copy(panel.derma)
    panel.derma = nil

    -- key value table to fast access modules
    panel._modules = {}

    -- each module can have an init function, store them as well
    panel._moduleInit = {}

    -- PANELS CAN INHERIT FROM SHARED MODULES
    for i = 1, #(panel.implements or {}) do
        local moduleName = panel.implements[i]
        local baseModule = table.FullCopy(basePanels[moduleName])

        if not baseModule then
            continue
        end

        panel._modules[moduleName] = true
        panel._moduleInit[#panel._moduleInit + 1] = panel.InternalSetup
        panel.InternalSetup = nil

        table.DeepInherit(panel, baseModule)
    end

    panel.implements = nil

    -- derma.DefineControl adds an Init() function if none is set instead of inheriting
    -- from the parent, therefore we manually call the parent Init() if not set
    local oldInit = panel.Init

    panel.Init = function(slf)
        for i = 1, #(slf._moduleInit or {}) do
            slf._moduleInit[i](slf)
        end

        slf._moduleInit = nil

        -- we don't have to call the init of the base class here, GMod already does this:
        -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/client/panel/scriptedpanels.lua#L23-L52

        if isfunction(oldInit) then
            oldInit(slf)
        end
    end

    derma.DefineControl(dermaInfo.className, dermaInfo.description, panel, dermaInfo.baseClassName)
end

function derma.InitializeElements()
    classbuilder.BuildFromFolder(
        "terrortown/derma/modules/",
        CLIENT_FILE,
        "METAPANEL",
        function(panel, path, name)
            basePanels[name] = panel
            panel.name = nil
        end
    )

    classbuilder.BuildFromFolder("terrortown/derma/core/", CLIENT_FILE, "DPANEL", BuildPanel)
    classbuilder.BuildFromFolder("terrortown/derma/variants/", CLIENT_FILE, "DPANEL", BuildPanel)
    classbuilder.BuildFromFolder("terrortown/derma/menus/", CLIENT_FILE, "DPANEL", BuildPanel)
    classbuilder.BuildFromFolder(
        "terrortown/derma/menus/elements/",
        CLIENT_FILE,
        "DPANEL",
        BuildPanel
    )
end

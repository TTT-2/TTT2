---
-- derma extensions
-- @author Mineotopia
-- @module derma

if SERVER then
    AddCSLuaFile()

    fileloader.LoadFolder("terrortown/derma/core/", false, CLIENT_FILE)
    fileloader.LoadFolder("terrortown/derma/modules/", false, CLIENT_FILE)

    return
end

local basePanels = {}

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

    classbuilder.BuildFromFolder(
        "terrortown/derma/core/",
        CLIENT_FILE,
        "DPANEL",
        function(panel, path, name)
            -- DERMA INFO TABLE CONTAINS REGISTRATION DATA
            local dermaInfo = table.Copy(panel.derma)
            panel.derma = nil

            -- key value table to fast access modules
            panel._modules = {}

            -- PANELS CAN INHERIT FROM SHARED MODULES
            for i = 1, #(panel.implements or {}) do
                local moduleName = panel.implements[i]
                local baseModule = basePanels[moduleName]

                if not baseModule then
                    continue
                end

                panel._modules[moduleName] = true

                table.DeepInherit(panel, baseModule)
            end

            panel.implements = nil

            -- derma.DefineControl adds an Init() function if none is set instead of inheriting
            -- from the parent, therefore we manually call the parent Init() if not set
            panel.Init = panel.Init
                or function(slf)
                    DBase(dermaInfo.baseClassName).Init(slf)
                end

            derma.DefineControl(
                dermaInfo.className,
                dermaInfo.description,
                panel,
                dermaInfo.baseClassName
            )
        end
    )
end

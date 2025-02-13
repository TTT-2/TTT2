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

    PrintTable(basePanels)

    classbuilder.BuildFromFolder(
        "terrortown/derma/core/",
        CLIENT_FILE,
        "DPANEL",
        function(panel, path, name)
            -- DERMA INFO TABLE CONTAINS REGISTRATION DATA
            local dermaInfo = table.Copy(panel.derma)
            panel.derma = nil

            -- PANELS CAN INHERIT FROM SHARED MODULES
            for i = 1, #(panel.modules or {}) do
                local baseModule = basePanels[panel.modules[i]]

                if not baseModule then
                    continue
                end

                table.DeepInherit(panel, baseModule)
            end

            panel.modules = nil

            derma.DefineControl(
                dermaInfo.className,
                dermaInfo.description,
                panel,
                dermaInfo.baseClassName
            )
        end
    )
end

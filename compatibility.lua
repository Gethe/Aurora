local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals pairs type

-- External Addon Compatibility Module
-- Handles compatibility checks, conflict detection, and safe mode operation

local Compatibility = {}
private.Compatibility = Compatibility

-- Known conflicting addons and their impact
Compatibility.conflicts = {
    -- Bag addons that conflict with Aurora's bag theming
    ["Bagnon"] = {
        component = "bags",
        severity = "warning",
        message = "Bagnon detected. Consider disabling Aurora's bag theming to avoid conflicts."
    },
    ["AdiBags"] = {
        component = "bags",
        severity = "warning",
        message = "AdiBags detected. Consider disabling Aurora's bag theming to avoid conflicts."
    },
    ["ArkInventory"] = {
        component = "bags",
        severity = "warning",
        message = "ArkInventory detected. Consider disabling Aurora's bag theming to avoid conflicts."
    },
    
    -- Tooltip addons
    ["TipTac"] = {
        component = "tooltips",
        severity = "warning",
        message = "TipTac detected. Consider disabling Aurora's tooltip theming to avoid conflicts."
    },
    
    -- Chat addons
    ["Prat"] = {
        component = "chat",
        severity = "warning",
        message = "Prat detected. Consider disabling Aurora's chat theming to avoid conflicts."
    },
    ["Chatter"] = {
        component = "chat",
        severity = "warning",
        message = "Chatter detected. Consider disabling Aurora's chat theming to avoid conflicts."
    },
    
    -- Action bar addons
    ["Bartender4"] = {
        component = "mainmenubar",
        severity = "info",
        message = "Bartender4 detected. Aurora's main menu bar theming may not be needed."
    },
    ["Dominos"] = {
        component = "mainmenubar",
        severity = "info",
        message = "Dominos detected. Aurora's main menu bar theming may not be needed."
    },
}

-- Required dependencies
Compatibility.dependencies = {
    ["Blizzard_Deprecated"] = {
        required = true,
        message = "Blizzard_Deprecated is required for Aurora to function properly."
    },
}

-- Compatibility state
Compatibility.safeMode = false
Compatibility.detectedConflicts = {}
Compatibility.missingDependencies = {}

-- Check if an addon is loaded
-- @param addonName string The addon name to check
-- @return boolean Whether the addon is loaded
local function isAddonLoaded(addonName)
    if _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded then
        return _G.C_AddOns.IsAddOnLoaded(addonName)
    elseif _G.IsAddOnLoaded then
        return _G.IsAddOnLoaded(addonName)
    end
    return false
end

-- Check for conflicting addons
-- @return table List of detected conflicts
function Compatibility.checkConflicts()
    local conflicts = {}
    
    for addonName, conflictInfo in pairs(Compatibility.conflicts) do
        if isAddonLoaded(addonName) then
            conflicts[#conflicts + 1] = {
                addon = addonName,
                component = conflictInfo.component,
                severity = conflictInfo.severity,
                message = conflictInfo.message
            }
            private.debug("Compatibility", "Conflict detected:", addonName)
        end
    end
    
    Compatibility.detectedConflicts = conflicts
    return conflicts
end

-- Check for missing dependencies
-- @return table List of missing dependencies
function Compatibility.checkDependencies()
    local missing = {}
    
    for depName, depInfo in pairs(Compatibility.dependencies) do
        if depInfo.required and not isAddonLoaded(depName) then
            missing[#missing + 1] = {
                dependency = depName,
                message = depInfo.message
            }
            private.debug("Compatibility", "Missing dependency:", depName)
        end
    end
    
    Compatibility.missingDependencies = missing
    return missing
end

-- Enable safe mode operation
-- Safe mode disables potentially problematic features
function Compatibility.enableSafeMode()
    Compatibility.safeMode = true
    private.debug("Compatibility", "Safe mode enabled")
end

-- Check if safe mode is active
-- @return boolean Whether safe mode is enabled
function Compatibility.isSafeMode()
    return Compatibility.safeMode
end

-- Apply compatibility adjustments based on detected conflicts
-- @param config table The configuration object
function Compatibility.applyAdjustments(config)
    if not config then
        return
    end
    
    -- Auto-disable conflicting components if in safe mode
    if Compatibility.safeMode then
        for _, conflict in pairs(Compatibility.detectedConflicts) do
            if conflict.component and config[conflict.component] then
                config[conflict.component] = false
                private.debug("Compatibility", "Auto-disabled", conflict.component, "due to conflict with", conflict.addon)
            end
        end
    end
end

-- Report compatibility issues to the user
function Compatibility.reportIssues()
    local conflicts = Compatibility.detectedConflicts
    local missing = Compatibility.missingDependencies
    
    -- Report missing dependencies (critical)
    if #missing > 0 then
        _G.print("|cffff0000Aurora:|r Critical dependency issues detected:")
        for _, dep in pairs(missing) do
            _G.print("  - " .. dep.message)
        end
    end
    
    -- Report conflicts (warnings)
    if #conflicts > 0 then
        local hasWarnings = false
        for _, conflict in pairs(conflicts) do
            if conflict.severity == "warning" then
                hasWarnings = true
                break
            end
        end
        
        if hasWarnings then
            _G.print("|cff00a0ffAurora:|r Potential addon conflicts detected:")
            for _, conflict in pairs(conflicts) do
                if conflict.severity == "warning" then
                    _G.print("  - " .. conflict.message)
                end
            end
        end
    end
end

-- Initialize compatibility system
-- @param config table The configuration object
-- @return boolean success Whether initialization succeeded
function Compatibility.initialize(config)
    private.debug("Compatibility", "Initializing compatibility checks")
    
    -- Check for missing dependencies
    local missing = Compatibility.checkDependencies()
    
    -- Check for conflicting addons
    local conflicts = Compatibility.checkConflicts()
    
    -- Enable safe mode if critical issues detected
    if #missing > 0 then
        Compatibility.enableSafeMode()
        private.debug("Compatibility", "Safe mode enabled due to missing dependencies")
    end
    
    -- Apply compatibility adjustments
    Compatibility.applyAdjustments(config)
    
    -- Report issues to user (delayed to avoid spam during loading)
    _G.C_Timer.After(2, function()
        Compatibility.reportIssues()
    end)
    
    return #missing == 0
end

-- Get compatibility status summary
-- @return table Status information
function Compatibility.getStatus()
    return {
        safeMode = Compatibility.safeMode,
        conflicts = Compatibility.detectedConflicts,
        missingDependencies = Compatibility.missingDependencies,
        hasIssues = #Compatibility.detectedConflicts > 0 or #Compatibility.missingDependencies > 0
    }
end

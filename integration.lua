local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals pairs type pcall xpcall

-- System Integration Module
-- Handles module coordination, error handling, recovery mechanisms, and performance optimization

local Integration = {}
private.Integration = Integration

-- Integration state
Integration.initialized = false
Integration.modules = {}
Integration.eventHandlers = {}
Integration.errorLog = {}
Integration.performanceMetrics = {}

-- Error handling and recovery

--[[ Integration.RegisterErrorHandler(_moduleName, handler_)
Register an error handler for a specific module.

**Args:**
* `moduleName` - the module name _(string)_
* `handler` - error handler function _(function)_
--]]
function Integration.RegisterErrorHandler(moduleName, handler)
    if not moduleName or type(handler) ~= "function" then
        return false
    end

    Integration.errorHandlers = Integration.errorHandlers or {}
    Integration.errorHandlers[moduleName] = handler

    private.debug("Integration", "Registered error handler for", moduleName)
    return true
end

--[[ Integration.HandleError(_moduleName, error, context_)
Handle an error from a module with recovery attempt.

**Args:**
* `moduleName` - the module where error occurred _(string)_
* `error` - the error message or object _(any)_
* `context` - additional context information _(table)_

**Returns:**
* `recovered` - whether error was recovered _(boolean)_
--]]
function Integration.HandleError(moduleName, error, context)
    -- Log the error
    local errorEntry = {
        module = moduleName,
        error = error,
        context = context or {},
        timestamp = _G.time(),
    }

    Integration.errorLog[#Integration.errorLog + 1] = errorEntry

    private.debug("Integration", "Error in", moduleName, ":", error)

    -- Try module-specific error handler
    if Integration.errorHandlers and Integration.errorHandlers[moduleName] then
        local success, recovered = pcall(Integration.errorHandlers[moduleName], error, context)
        if success and recovered then
            private.debug("Integration", "Error recovered by module handler")
            return true
        end
    end

    -- Generic recovery attempts
    if context and context.recoverable then
        private.debug("Integration", "Attempting generic recovery")
        return Integration.AttemptRecovery(moduleName, error, context)
    end

    return false
end

--[[ Integration.AttemptRecovery(_moduleName, error, context_)
Attempt generic error recovery.

**Args:**
* `moduleName` - the module name _(string)_
* `error` - the error _(any)_
* `context` - error context _(table)_

**Returns:**
* `recovered` - whether recovery succeeded _(boolean)_
--]]
function Integration.AttemptRecovery(moduleName, error, context)
    -- Attempt to reload module configuration
    if moduleName == "Config" then
        local Config = private.Config
        if Config and Config.recover then
            local success, _ = pcall(Config.recover)
            if success then
                private.debug("Integration", "Config recovery successful")
                return true
            end
        end
    end

    -- Attempt to reinitialize module
    if private[moduleName] and private[moduleName].initialize then
        local success = pcall(private[moduleName].initialize)
        if success then
            private.debug("Integration", "Module reinitialization successful")
            return true
        end
    end

    return false
end

--[[ Integration.GetErrorLog()
Get the error log.

**Returns:**
* `errorLog` - array of error entries _(table)_
--]]
function Integration.GetErrorLog()
    return Integration.errorLog
end

--[[ Integration.ClearErrorLog()
Clear the error log.
--]]
function Integration.ClearErrorLog()
    Integration.errorLog = {}
    private.debug("Integration", "Error log cleared")
end

-- Event coordination system

--[[ Integration.RegisterEventHandler(_event, moduleName, handler_)
Register an event handler for a module.

**Args:**
* `event` - the event name _(string)_
* `moduleName` - the module name _(string)_
* `handler` - event handler function _(function)_
--]]
function Integration.RegisterEventHandler(event, moduleName, handler)
    if not event or not moduleName or type(handler) ~= "function" then
        return false
    end

    if not Integration.eventHandlers[event] then
        Integration.eventHandlers[event] = {}
    end

    Integration.eventHandlers[event][moduleName] = handler

    private.debug("Integration", "Registered event handler:", event, "for", moduleName)
    return true
end

--[[ Integration.UnregisterEventHandler(_event, moduleName_)
Unregister an event handler.

**Args:**
* `event` - the event name _(string)_
* `moduleName` - the module name _(string)_
--]]
function Integration.UnregisterEventHandler(event, moduleName)
    if Integration.eventHandlers[event] then
        Integration.eventHandlers[event][moduleName] = nil
        return true
    end
    return false
end

--[[ Integration.DispatchEvent(_event, ..._)
Dispatch an event to all registered handlers.

**Args:**
* `event` - the event name _(string)_
* `...` - event arguments _(any)_

**Returns:**
* `handled` - number of handlers that processed the event _(number)_
* `failed` - number of handlers that failed _(number)_
--]]
function Integration.DispatchEvent(event, ...)
    if not Integration.eventHandlers[event] then
        return 0, 0
    end

    local handled = 0
    local failed = 0

    for moduleName, handler in pairs(Integration.eventHandlers[event]) do
        local success, err = xpcall(handler, function(msg)
            return msg .. "\n" .. _G.debugstack(2)
        end, ...)

        if success then
            handled = handled + 1
        else
            failed = failed + 1
            Integration.HandleError(moduleName, err, {
                event = event,
                recoverable = false
            })
        end
    end

    return handled, failed
end

-- Performance optimization

--[[ Integration.StartPerformanceTracking(_operation_)
Start tracking performance for an operation.

**Args:**
* `operation` - the operation name _(string)_

**Returns:**
* `trackingId` - tracking identifier _(number)_
--]]
function Integration.StartPerformanceTracking(operation)
    local trackingId = _G.debugprofilestop()

    Integration.performanceMetrics[trackingId] = {
        operation = operation,
        startTime = trackingId,
        endTime = nil,
        duration = nil,
    }

    return trackingId
end

--[[ Integration.EndPerformanceTracking(_trackingId_)
End performance tracking for an operation.

**Args:**
* `trackingId` - the tracking identifier _(number)_

**Returns:**
* `duration` - operation duration in milliseconds _(number)_
--]]
function Integration.EndPerformanceTracking(trackingId)
    local metric = Integration.performanceMetrics[trackingId]
    if not metric then
        return nil
    end

    metric.endTime = _G.debugprofilestop()
    metric.duration = metric.endTime - metric.startTime

    private.debug("Integration", "Performance:", metric.operation, "took", metric.duration, "ms")

    return metric.duration
end

--[[ Integration.GetPerformanceMetrics()
Get all performance metrics.

**Returns:**
* `metrics` - table of performance metrics _(table)_
--]]
function Integration.GetPerformanceMetrics()
    local metrics = {}

    for _, metric in pairs(Integration.performanceMetrics) do
        if metric.duration then
            metrics[#metrics + 1] = {
                operation = metric.operation,
                duration = metric.duration,
            }
        end
    end

    return metrics
end

--[[ Integration.OptimizeMemoryUsage()
Optimize memory usage by cleaning up unused resources.

**Returns:**
* `freed` - estimated memory freed in KB _(number)_
--]]
function Integration.OptimizeMemoryUsage()
    local beforeMemory = _G.collectgarbage("count")

    -- Clear old error log entries (keep last 100)
    if #Integration.errorLog > 100 then
        local newLog = {}
        for i = #Integration.errorLog - 99, #Integration.errorLog do
            newLog[#newLog + 1] = Integration.errorLog[i]
        end
        Integration.errorLog = newLog
    end

    -- Clear old performance metrics (keep last 50)
    local metricsArray = {}
    for id, metric in pairs(Integration.performanceMetrics) do
        if metric.duration then
            metricsArray[#metricsArray + 1] = {id = id, metric = metric}
        end
    end

    if #metricsArray > 50 then
        -- Sort by end time and keep most recent
        table.sort(metricsArray, function(a, b)
            return (a.metric.endTime or 0) > (b.metric.endTime or 0)
        end)

        local newMetrics = {}
        for i = 1, 50 do
            newMetrics[metricsArray[i].id] = metricsArray[i].metric
        end
        Integration.performanceMetrics = newMetrics
    end

    -- Run garbage collection
    _G.collectgarbage("collect")

    local afterMemory = _G.collectgarbage("count")
    local freed = beforeMemory - afterMemory

    private.debug("Integration", "Memory optimization freed", freed, "KB")

    return freed
end

-- Module coordination

--[[ Integration.RegisterModule(_moduleName, module_)
Register a module with the integration system.

**Args:**
* `moduleName` - the module name _(string)_
* `module` - the module table _(table)_
--]]
function Integration.RegisterModule(moduleName, module)
    if not moduleName or not module then
        return false
    end

    Integration.modules[moduleName] = module

    private.debug("Integration", "Registered module:", moduleName)
    return true
end

--[[ Integration.GetModule(_moduleName_)
Get a registered module.

**Args:**
* `moduleName` - the module name _(string)_

**Returns:**
* `module` - the module table or nil _(table|nil)_
--]]
function Integration.GetModule(moduleName)
    return Integration.modules[moduleName]
end

--[[ Integration.InitializeAllModules()
Initialize all registered modules in proper order.

**Returns:**
* `initialized` - number of modules initialized _(number)_
* `failed` - number of modules that failed _(number)_
--]]
function Integration.InitializeAllModules()
    local initialized = 0
    local failed = 0

    -- Define initialization order
    local initOrder = {
        "Config",
        "Analytics",
        "Compatibility",
        "Theme",
    }

    for _, moduleName in pairs(initOrder) do
        local module = Integration.modules[moduleName]
        if module and module.initialize then
            local trackingId = Integration.StartPerformanceTracking("Initialize " .. moduleName)

            local success, err = xpcall(module.initialize, function(msg)
                return msg .. "\n" .. _G.debugstack(2)
            end)

            Integration.EndPerformanceTracking(trackingId)

            if success then
                initialized = initialized + 1
                private.debug("Integration", "Initialized module:", moduleName)
            else
                failed = failed + 1
                Integration.HandleError(moduleName, err, {
                    phase = "initialization",
                    recoverable = true
                })
            end
        end
    end

    return initialized, failed
end

--[[ Integration.WireModules()
Wire all modules together with proper event handling.

**Returns:**
* `success` - whether wiring succeeded _(boolean)_
--]]
function Integration.WireModules()
    private.debug("Integration", "Wiring modules together")

    -- Register Config module events
    Integration.RegisterEventHandler("CONFIG_CHANGED", "Theme", function(key, value)
        local Aurora = private.Aurora
        if Aurora and Aurora.Theme then
            -- Handle alpha changes
            if key == "alpha" and Aurora.Theme.SetGlobalAlpha then
                Aurora.Theme.SetGlobalAlpha(value)
            end

            -- Handle color changes
            if key == "customHighlight" and private.updateHighlightColor then
                private.updateHighlightColor()
            end
        end
    end)

    -- Register Analytics events
    Integration.RegisterEventHandler("CONFIG_CHANGED", "Analytics", function(key, value)
        local Analytics = private.Analytics
        if Analytics and Analytics.trackConfigChange then
            Analytics.trackConfigChange(key, value)
        end
    end)

    -- Register Compatibility events
    Integration.RegisterEventHandler("ADDON_LOADED", "Compatibility", function(addonName)
        local Compatibility = private.Compatibility
        if Compatibility and Compatibility.checkConflicts then
            Compatibility.checkConflicts()
        end
    end)

    private.debug("Integration", "Module wiring complete")
    return true
end

--[[ Integration.Initialize()
Initialize the integration system.

**Returns:**
* `success` - whether initialization succeeded _(boolean)_
--]]
function Integration.Initialize()
    if Integration.initialized then
        return true
    end

    private.debug("Integration", "Initializing integration system")

    -- Register core modules
    Integration.RegisterModule("Config", private.Config)
    Integration.RegisterModule("Analytics", private.Analytics)
    Integration.RegisterModule("Compatibility", private.Compatibility)
    Integration.RegisterModule("Theme", private.Aurora and private.Aurora.Theme)

    -- Wire modules together
    Integration.WireModules()

    -- Set up periodic optimization
    _G.C_Timer.NewTicker(300, function() -- Every 5 minutes
        Integration.OptimizeMemoryUsage()

        -- Optimize theme engine if available
        local Aurora = private.Aurora
        if Aurora and Aurora.Theme and Aurora.Theme.OptimizeFrameProcessing then
            Aurora.Theme.OptimizeFrameProcessing()
        end
    end)

    Integration.initialized = true
    private.debug("Integration", "Integration system initialized")

    return true
end

--[[ Integration.GetStatus()
Get integration system status.

**Returns:**
* `status` - status information table _(table)_
--]]
function Integration.GetStatus()
    return {
        initialized = Integration.initialized,
        moduleCount = 0, -- Count registered modules
        errorCount = #Integration.errorLog,
        eventHandlerCount = 0, -- Count event handlers
        performanceMetricsCount = 0, -- Count metrics
    }
end


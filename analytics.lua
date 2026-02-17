local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals pairs type

-- Analytics Integration Module
-- Handles WagoAnalytics integration, user consent, privacy controls, and event tracking

local Analytics = {}
private.Analytics = Analytics

-- Analytics state
Analytics.enabled = false
Analytics.wago = nil
Analytics.consentGiven = nil

-- Initialize analytics system
-- @param wago table The WagoAnalytics instance
-- @param config table The configuration object
function Analytics.initialize(wago, config)
    Analytics.wago = wago

    -- Check if user has given consent (hasAnalytics setting)
    Analytics.consentGiven = config.hasAnalytics
    Analytics.enabled = Analytics.consentGiven and wago ~= nil

    if Analytics.enabled then
        private.debug("Analytics", "Initialized with user consent")
    else
        private.debug("Analytics", "Disabled - consent:", Analytics.consentGiven, "wago:", wago ~= nil)
    end
end

-- Track a configuration change event
-- @param key string The configuration key that changed
-- @param value any The new value
function Analytics.trackConfigChange(key, value)
    if not Analytics.enabled or not Analytics.wago then
        return
    end

    -- Skip tracking for privacy-sensitive settings
    if key == "acknowledgedSplashScreen" or key == "hasAnalytics" then
        return
    end

    -- Track based on value type
    if key == "customHighlight" then
        -- Track custom highlight enable/disable
        if type(value) == "table" and value.enabled ~= nil then
            Analytics.wago:Switch(key, value.enabled)
        end
    elseif key == "alpha" then
        -- Track numeric values as counters
        if type(value) == "number" then
            Analytics.wago:SetCounter(key, value)
        end
    elseif type(value) == "boolean" then
        -- Track boolean toggles
        Analytics.wago:Switch(key, value)
    end

    private.debug("Analytics", "Tracked config change:", key, "=", value)
end

-- Enable analytics with user consent
-- @param config table The configuration object
function Analytics.enable(config)
    if not Analytics.wago then
        private.debug("Analytics", "Cannot enable - WagoAnalytics not available")
        return false
    end

    config.hasAnalytics = true
    Analytics.consentGiven = true
    Analytics.enabled = true

    private.debug("Analytics", "Enabled with user consent")
    return true
end

-- Disable analytics and revoke consent
-- @param config table The configuration object
function Analytics.disable(config)
    config.hasAnalytics = false
    Analytics.consentGiven = false
    Analytics.enabled = false

    private.debug("Analytics", "Disabled by user")
    return true
end

-- Check if analytics is available
-- @return boolean Whether WagoAnalytics is available
function Analytics.isAvailable()
    return Analytics.wago ~= nil
end

-- Check if user has given consent
-- @return boolean Whether user has consented to analytics
function Analytics.hasConsent()
    return Analytics.consentGiven == true
end

-- Track initial configuration state
-- @param config table The configuration object
function Analytics.trackInitialState(config)
    if not Analytics.enabled or not Analytics.wago then
        return
    end

    -- Track all non-sensitive settings
    for key, value in pairs(config) do
        if key ~= "acknowledgedSplashScreen" and key ~= "hasAnalytics" and key ~= "customClassColors" then
            Analytics.trackConfigChange(key, value)
        end
    end

    private.debug("Analytics", "Tracked initial configuration state")
end

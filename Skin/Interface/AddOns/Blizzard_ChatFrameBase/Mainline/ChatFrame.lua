local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals _G pcall type next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local function IsSecret(value)
    return (_G.issecretvalue and _G.issecretvalue(value)) or (_G.issecrettable and _G.issecrettable(value))
end

local function SafeString(value, fallback)
    if IsSecret(value) then
        return fallback or ""
    end
    if type(value) ~= "string" then
        return fallback or ""
    end
    return value
end

local function SafeAmbiguate(name, context)
    name = SafeString(name, "")
    if name == "" then
        return ""
    end
    if not _G.Ambiguate then
        return name
    end

    local ok, result = pcall(_G.Ambiguate, name, context)
    if ok then
        return SafeString(result, name)
    end
    return ""
end

do --[[ SharedXML\ChatFrame.lua ]]
    function Hook.ChatFrameEditBoxMixinUpdateHeader(editBox)
        local chatType = editBox:GetAttribute("chatType")
        if not chatType then
            editBox:SetBackdropBorderColor(Color.frame)
            return
        end

        local info = _G.ChatTypeInfo[chatType]
        if chatType == "CHANNEL" then
            local channeleditBox = _G.ChatFrameUtil.GetActiveWindow();
            local localID, channelName = _G.GetChannelName(channeleditBox:GetChannelTarget())
            if channelName then
                info = _G.ChatTypeInfo["CHANNEL"..localID]
            end
        end

        editBox:SetBackdropBorderColor(info.r, info.g, info.b)
    end

    function Hook.GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
        local chatType = event:sub(10)
        if ( chatType:sub(1, 7) == "WHISPER" ) then
            chatType = "WHISPER"
        end
        if ( chatType:sub(1, 7) == "CHANNEL" ) then
            chatType = "CHANNEL"..arg8
        end

        --ambiguate guild chat names
        if (chatType == "GUILD") then
            arg2 = SafeAmbiguate(arg2, "guild")
        else
            arg2 = SafeAmbiguate(arg2, "none")
        end

        local info = _G.ChatTypeInfo[chatType]
        if arg12 and info and _G.Chat_ShouldColorChatByClass(info) then
            local _, classToken = _G.GetPlayerInfoByGUID(arg12)

            if classToken then
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                if color then
                    return ("|c%s%s|r"):format(color.colorStr, arg2)
                end
            end
        end

        return arg2
    end
end

do --[[ SharedXML\ChatFrame.xml ]]
    function Skin.ChatFrameTemplate(ScrollingMessageFrame)
        if private.isRetail then
            Skin.MinimalScrollBar(ScrollingMessageFrame.ScrollBar)
        end
    end
    function Skin.ChatFrameEditBoxTemplate(EditBox)
        Skin.FrameTypeEditBox(EditBox)

        local name = EditBox:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Mid"]:Hide()
        if private.isRetail then
            EditBox.focusLeft:SetAlpha(0)
            EditBox.focusRight:SetAlpha(0)
            EditBox.focusMid:SetAlpha(0)
        end
        EditBox.header:SetPoint("LEFT", 10, 0)
    end
end

function private.SharedXML.ChatFrame()
    if private.disabled.chat then return end
    _G.hooksecurefunc("ChatEdit_UpdateHeader", Hook.ChatFrameEditBoxMixinUpdateHeader)

    _G.GetColoredName = Hook.GetColoredName

    if _G.ChatFrameUtil and _G.ChatFrameUtil.GetDecoratedSenderName then
        _G.ChatFrameUtil.GetDecoratedSenderName = function(event, ...)
            local _, senderName, _, _, _, _, _, channelIndex, _, _, _, senderGUID, _, _ = ...
            local chatType = event:sub(10)

            if chatType:find("^WHISPER") then
                chatType = "WHISPER"
            end

            if chatType:find("^CHANNEL") then
                chatType = "CHANNEL" .. channelIndex
            end

            local chatTypeInfo = _G.ChatTypeInfo[chatType]
            local decoratedPlayerName = SafeString(senderName, "")

            if _G.Ambiguate then
                if chatType == "GUILD" then
                    decoratedPlayerName = SafeAmbiguate(decoratedPlayerName, "guild")
                else
                    decoratedPlayerName = SafeAmbiguate(decoratedPlayerName, "none")
                end
            end

            if senderGUID and _G.C_ChatInfo.IsTimerunningPlayer(senderGUID) then
                decoratedPlayerName = _G.TimerunningUtil.AddSmallIcon(decoratedPlayerName)
            end

            if senderGUID and chatTypeInfo and _G.ChatFrameUtil.ShouldColorChatByClass(chatTypeInfo) and _G.GetPlayerInfoByGUID ~= nil then
                local _, englishClass = _G.GetPlayerInfoByGUID(senderGUID)

                if englishClass then
                    local classColor = _G.RAID_CLASS_COLORS[englishClass]

                    if classColor then
                        decoratedPlayerName = classColor:WrapTextInColorCode(decoratedPlayerName)
                    end
                end
            end

            decoratedPlayerName = _G.ChatFrameUtil.ProcessSenderNameFilters(event, decoratedPlayerName, ...)
            return decoratedPlayerName
        end
    end

    --[[
    local AddMessage = {}
    local function FixClassColors(frame, message, ...) -- 3174
        if type(message) == "string" and message:find("|cff") then -- type check required for shitty addons that pass nil or non-string values
            for classToken, classColor in next, _G.RAID_CLASS_COLORS do
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                message = color and message:gsub(classColor.colorStr, color.colorStr) or message -- color check required for Warmup, maybe others
            end
        end
        return AddMessage[frame](frame, message, ...)
    end

    for i = 1, _G.Constants.ChatFrameConstants.MaxChatWindows do
        local frame = _G["ChatFrame"..i]
        AddMessage[frame] = frame.AddMessage
        frame.AddMessage = FixClassColors
    end
    ]]
end

-- StickyTarget: toggle `deselectOnClick` when entering/exiting combat
-- Current WoW API compliant implementation using C_CVar and safe event handling.
local CreateFrame = CreateFrame
local C_CVar = C_CVar
local C_Timer = C_Timer

local desiredValue = 1
local enabled = true

local function setDeselectOnClick(value)
  if C_CVar and C_CVar.SetCVar then
    C_CVar.SetCVar("deselectOnClick", tostring(value))
  else
    SetCVar("deselectOnClick", value)
  end
end

local function getDeselectOnClick()
  if C_CVar and C_CVar.GetCVar then
    return C_CVar.GetCVar("deselectOnClick")
  end
  return GetCVar("deselectOnClick")
end

local function enforceCVar()
  if not enabled then
    return
  end

  local current = getDeselectOnClick()
  if tostring(current) ~= tostring(desiredValue) then
    setDeselectOnClick(desiredValue)
    if C_Timer then
      C_Timer.After(0.1, function()
        if tostring(getDeselectOnClick()) ~= tostring(desiredValue) then
          setDeselectOnClick(desiredValue)
        end
      end)
    end
  end
end

local function onEvent(self, event, ...)
  if event == "PLAYER_LOGIN" then
    desiredValue = 1
    enforceCVar()
  elseif event == "PLAYER_ENTERING_WORLD" then
    enforceCVar()
  elseif event == "PLAYER_REGEN_DISABLED" then
    desiredValue = 0
    enforceCVar()
  elseif event == "PLAYER_REGEN_ENABLED" then
    desiredValue = 1
    enforceCVar()
  elseif event == "CVAR_UPDATE" then
    local cvar = ...
    if enabled and cvar == "deselectOnClick" then
      enforceCVar()
    end
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("CVAR_UPDATE")
frame:SetScript("OnEvent", onEvent)

SLASH_STICKYTARGET1 = "/stickytarget"
SlashCmdList["STICKYTARGET"] = function(msg)
  local cmd = msg and msg:lower()
  if cmd == "on" then
    enabled = true
    desiredValue = 0
    enforceCVar()
    print("StickyTarget: enabled; desired deselectOnClick = 0")
  elseif cmd == "off" then
    enabled = false
    desiredValue = 1
    enforceCVar()
    print("StickyTarget: disabled; desired deselectOnClick = 1")
  else
    print("Usage: /stickytarget on|off")
  end
end

ShaguCopy = CreateFrame("Frame")
ShaguCopy:RegisterEvent("PLAYER_ENTERING_WORLD")
ShaguCopy:SetScript("OnEvent", function()

for i=1,NUM_CHAT_WINDOWS do
  local ChatFrame = getglobal("ChatFrame"..i)

  -- detect combat log by message groups
  local combat = 0
  for _, msg in pairs(ChatFrame.messageTypeList) do
    if strfind(msg, "SPELL", 1) or strfind(msg, "COMBAT", 1) then
      combat = combat + 1
    end
  end

  -- add chat copy button to non-combat frames
  if not ChatFrame.scrollframe and combat <= 5 then
    local HookAddMessage = ChatFrame.AddMessage
    local _, fontSize, _ = GetChatWindowInfo(i)

    ChatFrame.scrollframe = CreateFrame('ScrollFrame', 'ShaguChatCopyScroll', ChatFrame, 'UIPanelScrollFrameTemplate')
    ChatFrame.scrollframe:SetParent(ChatFrame)
    ChatFrame.scrollframe:SetAllPoints(ChatFrame)
    ChatFrame.scrollframe:SetScrollChild(ChatFrame.scrollframe.chatCopy)
    ChatFrame.scrollframe:Hide()
    ChatFrame.scrollframe:SetScript("OnUpdate", function()
      this:UpdateScrollChildRect()
    end)

    ChatFrame.scrollframe:SetScript("OnShow", function()
      this:SetScrollChild(ChatFrame.scrollframe.chatCopy)
      ChatFrame.scrollframe.chatCopy:SetAllPoints(ChatFrame.scrollframe)
      this:SetVerticalScroll(this:GetVerticalScrollRange())
    end)

    ChatFrame.scrollframe.bg = ChatFrame.scrollframe:CreateTexture(nil, "BACKGROUND")
    ChatFrame.scrollframe.bg:SetTexture(.1,.1,.1,1)
    ChatFrame.scrollframe.bg:SetPoint("TOPLEFT", ChatFrame.scrollframe, "TOPLEFT", -3, 3)
    ChatFrame.scrollframe.bg:SetPoint("BOTTOMRIGHT", ChatFrame.scrollframe, "BOTTOMRIGHT", 3, -5)

    ChatFrame.scrollframe.chatCopy = CreateFrame("EditBox", "ChatCopyBox" .. i, ChatFrame.scrollframe)
    ChatFrame.scrollframe.chatCopy:SetParent(ChatFrame.scrollframe)
    ChatFrame.scrollframe.chatCopy:SetHeight(300)
    ChatFrame.scrollframe.chatCopy:SetWidth(300)
    ChatFrame.scrollframe.chatCopy:SetAllPoints(ChatFrame.scrollframe)
    ChatFrame.scrollframe.chatCopy:SetTextColor(1,1.1,1)
    ChatFrame.scrollframe.chatCopy:SetMultiLine(true)

    ChatFrame.scrollframe.chatCopy:SetFontObject(ChatFontNormal)
    ChatFrame.scrollframe.chatCopy:SetAutoFocus(false)

    ChatFrame.scrollframe.chatCopy:SetScript("OnEscapePressed", function()
      this:ClearFocus()
      this:GetParent():Hide()
    end)

    ChatFrame.scrollframe.chatCopy:SetScript("OnEditFocusGained", function()
    end)

    ChatFrame.scrollframe:SetScrollChild(ChatFrame.scrollframe.chatCopy)

    ChatFrame.chatCopyButton = CreateFrame("Button", nil, ChatFrame)
    ChatFrame.chatCopyButton:SetPoint("TOPRIGHT", -3, -3)
    ChatFrame.chatCopyButton:SetFrameStrata("MEDIUM")
    ChatFrame.chatCopyButton:SetWidth(16)
    ChatFrame.chatCopyButton:SetHeight(16)
    ChatFrame.chatCopyButton:SetAlpha(.25)
    ChatFrame.chatCopyButton.icon = ChatFrame.chatCopyButton:CreateTexture(nil,"BACKGROUND")
    ChatFrame.chatCopyButton.icon:SetTexture("Interface\\AddOns\\ShaguCopy\\button")
    ChatFrame.chatCopyButton.icon:SetAllPoints(ChatFrame.chatCopyButton)
    ChatFrame.chatCopyButton:SetScript("OnClick", function(self)
      if ChatFrame.scrollframe:IsShown() then
        ChatFrame.scrollframe:Hide()
      else
        ChatFrame.scrollframe:Show()
      end
    end)

    ChatFrame.chatCopyButton:SetScript("OnEnter", function(self)
      this:SetAlpha(1)
    end)

    ChatFrame.chatCopyButton:SetScript("OnLeave", function(self)
      this:SetAlpha(.25)
    end)

    ChatFrame.AddMessage = function(frame, text, r, g, b, id)
      if text then
        frame.scrollframe.chatCopy:SetText(frame.scrollframe.chatCopy:GetText() .. "\n|cffffffff" .. text)
      end
        HookAddMessage(frame, text, r, g, b, id)
      end
    end
  end
end)

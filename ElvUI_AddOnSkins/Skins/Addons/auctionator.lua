local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("Auctionator") then return end

local _G = _G
local type = type
local unpack = unpack

local GetItemIcon = GetItemIcon
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

local auctionatorVersion = GetAddOnMetadata("Auctionator", "Version") or "0"
local isAuctionatorPlus = string.find(auctionatorVersion, "3%.")

local function BuildHooks(version)
	local SELL_TAB = 1
	local BUY_TAB = 3
	
	local function itemButtomSetNormalTexture(self, texture)
	    self.normalTexture:SetTexture(texture)
	end
	local function skinItemButtom(frame)
	    frame:StripTextures()
	    frame:SetTemplate("Default", true)
	    frame:StyleButton(nil, true)
	
	    frame:SetNormalTexture("")
	    frame.normalTexture = frame:GetNormalTexture()
	    frame.normalTexture:SetTexCoord(unpack(E.TexCoords))
	    frame.normalTexture:SetInside()
	    frame.SetNormalTexture = itemButtomSetNormalTexture
	end
	
	local function skinButtonHighlight(button)
	    local highlight = button:GetHighlightTexture()
	    highlight:SetTexCoord(0, 1, 0, 1)
	    highlight:SetTexture(E.Media.Textures.Highlight)
	    highlight:SetVertexColor(0.9, 0.9, 0.9, 0.35)
	
	    local pushed = button:GetPushedTexture()
	    pushed:SetTexCoord(0, 1, 0, 1)
	    pushed:SetTexture(E.Media.Textures.Highlight)
	    pushed:SetVertexColor(0.9, 0.9, 0.9, 0.35)
	end

	-- [Full Scan]
		hooksecurefunc("Atr_FullScanAnalyze", function()
	    	Atr_FullScanResults:SetBackdropColor(unpack(E.media.backdropfadecolor))
		end)

		hooksecurefunc("Atr_AuctionFrameTab_OnClick", function(self, index, down)
        	if not index or type(index) == "string" then
        	    index = self:GetID()
        	end

        	if Atr_IsAuctionatorTab(index) then
        	    if index == Atr_FindTabIndex(BUY_TAB) then
        	        Atr_Hlist:Height(242)
        	        Atr_Hlist_ScrollFrame:Height(242)
        	    else
        	        Atr_Hlist:Height(330)
        	        Atr_Hlist_ScrollFrame:Height(330)

        	        if index == Atr_FindTabIndex(SELL_TAB) then
        	            Atr_Hlist_ScrollFrame:_Hide()
        	            AuctionFrameMoneyFrame:Show()
        	        end
        	    end
        	end
    	end)

    	hooksecurefunc("Atr_SetTextureButton", function(elementName, count, itemlink)
    	    local button = _G[elementName]
    	    local buttonName = _G[elementName.."Name"]
	
    	    if GetItemIcon(itemlink) then
    	        local _, _, quality = GetItemInfo(itemlink)
    	        if quality then
    	            local r, g, b = GetItemQualityColor(quality)
	
    	            button:SetBackdropBorderColor(r, g, b)
    	            if buttonName then
    	                buttonName:SetTextColor(r, g, b)
    	            end
    	        else
    	            button:SetBackdropBorderColor(unpack(E.media.bordercolor))
    	            if buttonName then
    	                buttonName:SetTextColor(1, 0.82, 0)
    	            end
    	        end
    	    else
    	        button:SetBackdropBorderColor(unpack(E.media.bordercolor))
    	        if buttonName then
    	            buttonName:SetTextColor(1, 0.82, 0)
    	        end
    	    end
    	end)

    -- Atr_Init main hook
	S:SecureHook("Atr_Init", function()
	    S:Unhook("Atr_Init")
	
	    if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse then
	        for i = AuctionFrame.numTabs - 2, AuctionFrame.numTabs do
	            local tab = _G["AuctionFrameTab"..i]
	            S:HandleTab(tab)
	            tab:Point("LEFT", _G["AuctionFrameTab"..(i - 1)], "RIGHT", -15, 0)
	        end
	    end

	    -- [Main Auctionator frame]
		Atr_Main_Panel:Size(412, 424)

		Atr_Mask:Size(819, 422)
		Atr_Mask:Point("TOPLEFT", 12, -117)

		AuctionatorTitle:Point("TOP", 0, -5)

		S:HandleButton(Atr_FullScanButton)
		Atr_FullScanButton:Height(22)
		Atr_FullScanButton:Point("RIGHT", Auctionator1Button, "LEFT", -5, 0)

		S:HandleButton(Auctionator1Button)
		Auctionator1Button:Height(22)
		Auctionator1Button:Point("LEFT", Atr_Search_Button, "RIGHT", 177, 0)

		S:HandleButton(AuctionatorCloseButton)
		S:HandleButton(Atr_CancelSelectionButton)
		S:HandleButton(Atr_Buy1_Button)

		AuctionatorCloseButton:Point("BOTTOMRIGHT", 202, 8)
		Atr_Buy1_Button:Point("RIGHT", AuctionatorCloseButton, "LEFT", -5, 0)
		Atr_CancelSelectionButton:Point("RIGHT", Atr_Buy1_Button, "LEFT", -5, 0)

		-- [Main Auctionator frame: Left panel]
		Atr_Hlist:StripTextures()
		Atr_Hlist:SetTemplate("Transparent")
		Atr_Hlist:Width(172)
		Atr_Hlist:Point("TOPLEFT", -191, -57)
		
		Atr_Hlist_ScrollFrame:Width(172)
		Atr_Hlist_ScrollFrame:Point("TOPLEFT", -191, -57)
		Atr_Hlist_ScrollFrame._Hide = Atr_Hlist_ScrollFrame.Hide
		Atr_Hlist_ScrollFrame.Hide = E.noop
		
		S:HandleScrollBar(Atr_Hlist_ScrollFrameScrollBar)
		Atr_Hlist_ScrollFrameScrollBar:Point("TOPLEFT", Atr_Hlist_ScrollFrame, "TOPRIGHT", 3, -19)
		Atr_Hlist_ScrollFrameScrollBar:Point("BOTTOMLEFT", Atr_Hlist_ScrollFrame, "BOTTOMRIGHT", 3, 19)

		-- [Buy]
		-- [Buy: Left panel]
		S:HandleButton(Atr_RemFromSListButton)								--remove item from list
		
		for i = 1, 20 do -- ITEM_HIST_NUM_LINES
		    local button = _G["AuctionatorHEntry"..i]
		
		    button:Width(170)
		    skinButtonHighlight(button)
		
		    _G["AuctionatorHEntry"..i.."_EntryText"]:Width(168)
		
		    if i == 1 then
		        button:Point("TOPLEFT", 1, -1)
		    else
		        button:Point("TOPLEFT", 1, -1 - (i - 1) * 16)
		    end
		end

		S:HandleDropDownBox(Atr_DropDownSL, 221)
		 Atr_DropDownSL:Point("TOPLEFT", -211, -29)
		S:HandleEditBox(Atr_Search_Box)
		 Atr_Search_Box:Point("TOPLEFT", 20, -32)
		S:HandleButton(Atr_Search_Button)
		 Atr_Search_Button:Point("LEFT", Atr_Search_Box, "RIGHT", 6, 0)
		S:HandleButton(Atr_Adv_Search_Button)
		 Atr_Adv_Search_Button:Height(22)
		 Atr_Adv_Search_Button:Point("LEFT", Atr_Search_Button, "RIGHT", 5, 0)
		S:HandleButton(Atr_AddToSListButton)

		S:HandleButton(Atr_NewSListButton)								--New shopping list
		 Atr_NewSListButton:Width(193)
		 Atr_NewSListButton:Point("TOPLEFT", -191, -367)

		-- [Buy: Right panel]
		Atr_Hilite1:SetTemplate("Transparent", nil, true)
		Atr_Hilite1:SetBackdropColor(0, 0, 0, 0)
		Atr_Hilite1:Height(112)
		Atr_Hilite1:Point("TOPLEFT", 5, -57)
		Atr_Hilite1:Point("RIGHT", 202, 0)
		
		skinItemButtom(Atr_RecommendItem_Tex)
		
		AuctionatorMessageFrame:Point("TOP", 100, -65)
		AuctionatorMessage2Frame:Point("TOP", 100, -55)
		
		for i = 1, 3 do
		    local tab = _G["Atr_ListTabsTab"..i]
		    tab:StripTextures()
		    S:HandleButton(tab)
		    tab:Height(22)
		
		    if i ~= 3 then
		        tab:Point("RIGHT", _G["Atr_ListTabsTab"..(i + 1)], "LEFT", -3, 0)
		    end
		end
		
		Atr_HeadingsBar:StripTextures()
		Atr_HeadingsBar:Point("TOPLEFT", 6, -152)
		Atr_HeadingsBar:CreateBackdrop("Transparent")
		Atr_HeadingsBar.backdrop:Point("TOPLEFT", -1, -41)
		Atr_HeadingsBar.backdrop:Point("BOTTOMRIGHT", 3, -171)
		
		Atr_ListTabs:Point("BOTTOMRIGHT", Atr_HeadingsBar, "TOPRIGHT", 11, -22)
		
		AuctionatorScrollFrame:Height(194)
		AuctionatorScrollFrame:Point("TOPLEFT", 5, -193)
		
		S:HandleScrollBar(AuctionatorScrollFrameScrollBar)
		AuctionatorScrollFrameScrollBar:Point("TOPLEFT", AuctionatorScrollFrame, "TOPRIGHT", 3, -19)
		AuctionatorScrollFrameScrollBar:Point("BOTTOMLEFT", AuctionatorScrollFrame, "BOTTOMRIGHT", 3, 19)
		
		for _, tab in ipairs({Atr_Col1_Heading_Button, Atr_Col3_Heading_Button}) do
		    tab:StripTextures()
		    tab:SetNormalTexture([[Interface\Buttons\UI-SortArrow]])
		    tab:StyleButton()
		end
		
		AuctionatorEntry1:Point("TOPLEFT", AuctionatorScrollFrame, "TOPLEFT", 1, -1)
		
		for i = 1, 12 do
		    local button = _G["AuctionatorEntry"..i]
		    button:Width(586)
		    skinButtonHighlight(button)
		end
		
		AuctionatorScrollFrame:HookScript("OnShow", function(self)
		    Atr_HeadingsBar.backdrop:Point("BOTTOMRIGHT", -18, -171)
		end)
		AuctionatorScrollFrame:HookScript("OnHide", function(self)
		    Atr_HeadingsBar.backdrop:Point("BOTTOMRIGHT", 3, -171)
		end)

		S:HandleButton(Atr_Back_Button)
		 Atr_Back_Button:Height(22)
		 Atr_Back_Button:Point("TOPLEFT", 7, 13)

		-- [More...]
		S:HandleButton(Atr_CheckActiveButton)
		 Atr_CheckActiveButton:Size(193, 22)
		 Atr_CheckActiveButton:Point("TOPLEFT", -191, -394)

		-- [Sell tab]
			Atr_SellControls:SetTemplate("Transparent")
			Atr_SellControls:Size(193, 330)
			Atr_SellControls:Point("TOPLEFT", -191, -57)
			
			skinItemButtom(Atr_SellControls_Tex)
			Atr_SellControls_Tex:Point("TOPLEFT", 11, -14)
			
			Atr_StackPriceText:Point("TOPLEFT", 7, -56)
			Atr_ItemPriceText:Point("TOPLEFT", 7, -96)
			
			S:HandleButton(Atr_CreateAuctionButton)
			Atr_CreateAuctionButton:Point("TOPLEFT", 4, -139)

			
			Atr_Batch_Stacksize_Text:Point("TOPLEFT", 55, -177)
			Atr_Batch_NumAuctions:Point("TOPLEFT", Atr_Batch_Stacksize_Text, "TOPLEFT", -41, 0)
			
			Atr_Batch_MaxAuctions_Text:ClearAllPoints()
			Atr_Batch_MaxAuctions_Text:Point("BOTTOM", Atr_Batch_NumAuctions, 0, -14)
			Atr_Batch_MaxStacksize_Text:ClearAllPoints()
			Atr_Batch_MaxStacksize_Text:Point("BOTTOM", Atr_Batch_Stacksize, 0, -14)
			
			Atr_StartingPriceText:Point("TOPLEFT", 13, -229)
			Atr_StartingPriceDiscountText:Point("TOPLEFT", 10, -238)
			
			Atr_Duration_Text:Point("TOPLEFT", 10, -276)
			Atr_Duration_Text.SetPoint = E.noop
			S:HandleDropDownBox(Atr_Duration, 130)
			
			Atr_Deposit_Text:Point("TOPLEFT", 10, -304)
			
			S:HandleEditBox(Atr_StackPriceGold)
			S:HandleEditBox(Atr_StackPriceSilver)
			S:HandleEditBox(Atr_StackPriceCopper)
			S:HandleEditBox(Atr_ItemPriceGold)
			S:HandleEditBox(Atr_ItemPriceSilver)
			S:HandleEditBox(Atr_ItemPriceCopper)
			S:HandleEditBox(Atr_StartingPriceGold)
			S:HandleEditBox(Atr_StartingPriceSilver)
			S:HandleEditBox(Atr_StartingPriceCopper)
			S:HandleEditBox(Atr_Batch_NumAuctions)
			S:HandleEditBox(Atr_Batch_Stacksize)

	-- version specific stuff
	    if version == 2 then
		-- v2 specific
		--[Buy]
			Atr_AddToSListButton:Width(193)									--add item
			Atr_AddToSListButton:Point("TOPLEFT", -191, -304)

			S:HandleButton(Atr_DelSListButton)								--delete shopping list
			 Atr_DelSListButton:Width(193)
			 Atr_DelSListButton:Point("TOPLEFT", -191, -346)

			Atr_RemFromSListButton:Width(193)								--remove item from list
			Atr_RemFromSListButton:Point("TOPLEFT", -191, -325)

		-- [More...]
			S:HandleDropDownBox(Atr_DropDown1, 221)
			 Atr_DropDown1:Point("TOPLEFT", -211, -29)
		end

		if version == 3 then
		-- v3 specific
		-- [Buy]
			Atr_AddToSListButton:Width(96)									--add item
			Atr_AddToSListButton:Point("TOPLEFT", -191, -304)
			Atr_RemFromSListButton:Width(96)								--remove item
			Atr_RemFromSListButton:Point("TOPLEFT", -94, -304)
			S:HandleButton(Atr_MngSListsButton)								--manage Shopping Lists
			 Atr_MngSListsButton:Width(193)
			 Atr_MngSListsButton:Point("TOPLEFT", -191, -325)
			S:HandleButton(Atr_SrchSListButton)								--Search for All Items
			 Atr_SrchSListButton:Width(193)
			 Atr_SrchSListButton:Point("TOPLEFT", -191, -346)
		-- [Shopping lists]
			 S:HandleEditBox(Atr_Shplist_Edit_NameField)
			 S:HandleButton(Atr_Shplist_Edit_BTN_Add)
			  skinItemButtom(Atr_Shplist_Edit_BTN_Add)
			  Atr_Shplist_Edit_BTN_Add:SetNormalTexture("Interface\\AddOns\\ElvUI\\Media\\Textures\\Plus")
			-- edit shoplist screem
			 Atr_ShpList_Edit_FrameScrollFrame:StripTextures()
			 S:HandleScrollBar(Atr_ShpList_ScrollFrameScrollBar)
			  Atr_ShpList_ScrollFrameScrollBar:StripTextures()
			 S:HandleScrollBar(Atr_ShpList_Edit_FrameScrollFrameScrollBar)
			  Atr_ShpList_Edit_FrameScrollFrameScrollBar:StripTextures()


		end
	end) --end Atr_Init main hook
end

local function LoadAuctionatorCommonElements()
    -- Confirm Frame
    Atr_Confirm_Frame:SetTemplate("Transparent")
    S:HandleButton(Atr_Confirm_Cancel)
    S:HandleButton((select(2, Atr_Confirm_Frame:GetChildren())))

	-- [Error Frame]
		Atr_Error_Frame:SetTemplate("Transparent")
		S:HandleButton((Atr_Error_Frame:GetChildren()))

	-- [Full Scan]
		Atr_FullScanFrame:StripTextures()
		Atr_FullScanFrame:SetTemplate("Transparent")
		Atr_FullScanFrame:Height(424)
		Atr_FullScanFrame:Point("TOPLEFT", 215, -116)
		
		Atr_FullScanResults:SetTemplate("Transparent")
		
		S:HandleButton(Atr_FullScanStartButton)
		S:HandleButton(Atr_FullScanDone)
		S:HandleButton(Atr_ReloadUI)
		
		hooksecurefunc("Atr_ShowFullScanFrame", function()
		    Atr_FullScanFrame:SetBackdropColor(unpack(E.media.backdropfadecolor))
		end)

	-- [Buy]
	-- [Buy: BuyConfirm Frame]
		Atr_Buy_Confirm_Frame:SetTemplate("Transparent")
		S:HandleEditBox(Atr_Buy_Confirm_Numstacks)
		S:HandleButton(Atr_Buy_Confirm_OKBut)
		S:HandleButton(Atr_Buy_Confirm_CancelBut)

	-- [Buy: Advanced Search]
		Atr_Adv_Search_Dialog:StripTextures()
		Atr_Adv_Search_Dialog:SetTemplate("Transparent")
		Atr_Adv_Search_Dialog:Point("TOPLEFT", 215, -183)
		
		S:HandleEditBox(Atr_AS_Searchtext)
		S:HandleEditBox(Atr_AS_Minlevel)
		S:HandleEditBox(Atr_AS_Maxlevel)
		
		S:HandleDropDownBox(Atr_ASDD_Class, 180)
		S:HandleDropDownBox(Atr_ASDD_Subclass, 180)
		
		S:HandleButton(Atr_Adv_Search_ResetBut)
		S:HandleButton(Atr_Adv_Search_OKBut)
		S:HandleButton(Atr_Adv_Search_CancelBut)

	-- [More...]
	-- [More...: Check for undercuts dialog]
		Atr_CheckActives_Frame:StripTextures()
		Atr_CheckActives_Frame:SetTemplate("Transparent")
		
		local checkActivesButton1, checkActivesButton2 = Atr_CheckActives_Frame:GetChildren()
		S:HandleButton(checkActivesButton1)
		S:HandleButton(checkActivesButton2)

	-- [Config]
		Atr_BasicOptionsFrame:SetTemplate("Transparent")
		Atr_TooltipsOptionsFrame:SetTemplate("Transparent")
		Atr_UCConfigFrame:SetTemplate("Transparent")
		Atr_StackingOptionsFrame:SetTemplate("Transparent")
		Atr_ScanningOptionsFrame:SetTemplate("Transparent")
		AuctionatorDescriptionFrame:SetTemplate("Transparent")

		Atr_Stacking_List:SetTemplate("Transparent")

		S:HandleCheckBox(AuctionatorOption_Enable_Alt_CB)
		S:HandleCheckBox(AuctionatorOption_Open_All_Bags_CB)
		S:HandleCheckBox(AuctionatorOption_Show_StartingPrice_CB)

	-- [Config: Tooltips]
		S:HandleCheckBox(ATR_tipsVendorOpt_CB)
		S:HandleCheckBox(ATR_tipsAuctionOpt_CB)
		S:HandleCheckBox(ATR_tipsDisenchantOpt_CB)
		
		S:HandleDropDownBox(AuctionatorOption_Deftab)
		S:HandleDropDownBox(Atr_tipsShiftDD)
		S:HandleDropDownBox(Atr_deDetailsDD, 220)
		S:HandleDropDownBox(Atr_scanLevelDD)
		Atr_deDetailsDDText:SetJustifyH("RIGHT")

	-- [Config: Undercutting]
		local moneyEditBoxes = {
		    "UC_5000000_MoneyInput",
		    "UC_1000000_MoneyInput",
		    "UC_200000_MoneyInput",
		    "UC_50000_MoneyInput",
		    "UC_10000_MoneyInput",
		    "UC_2000_MoneyInput",
		    "UC_500_MoneyInput",
		}
		for _, name in ipairs(moneyEditBoxes) do
		    S:HandleEditBox(_G[name.."Gold"])
		    S:HandleEditBox(_G[name.."Silver"])
		    S:HandleEditBox(_G[name.."Copper"])
		end
		S:HandleEditBox(Atr_Starting_Discount)
		S:HandleButton(Atr_UCConfigFrame_Reset)

	-- [Config: Selling]
		S:HandleButton(Atr_StackingOptionsFrame_Edit)
		S:HandleButton(Atr_StackingOptionsFrame_New)

end

-- Auctionator 2.6.3: https://www.curseforge.com/wow/addons/auctionator/files/426882
local function LoadAuctionatorv2Elements()
	if not E.private.addOnSkins.Auctionator then return end
	LoadAuctionatorCommonElements()
	BuildHooks(2)

	-- [Config]
		S:HandleCheckBox(AuctionatorOption_Def_Duration_CB) --Set default duration checkbox
end

-- AuctionatorPlus 3.1.5: https://github.com/Intervence/AuctionatorPlus
local function LoadAuctionatorv3Elements()
	if not E.private.addOnSkins.Auctionator then return end
	LoadAuctionatorCommonElements()
	BuildHooks(3)
	-- Advanced Search
	S:HandleDropDownBox(Atr_ASDD_Rarity)

    -- [Config]
	-- [Config: Basic options]
		S:HandleButton(Atr_RB_N)
		S:HandleButton(Atr_RB_S)
		S:HandleButton(Atr_RB_M)
		S:HandleButton(Atr_RB_L)

	-- [Config: Database]
		Atr_ScanningOptionsFrame:SetTemplate("Transparent")
		S:HandleDropDownBox(Atr_scanLevelDD)
		S:HandleEditBox(Atr_ScanOpts_MaxHistAge)

    -- [Config: Data Reset]
    	local Atr_Clear_Frame = _G["AuctionatorResetsFrame"]
    	Atr_Clear_Frame:SetTemplate("Transparent")
        Atr_ConfirmClear_Frame:SetTemplate("Transparent")
        for _, child in ipairs({Atr_ConfirmClear_Frame:GetChildren()}) do
            if child:GetObjectType() == "Button" then
                S:HandleButton(child)
            end
        end


		for _, child in ipairs({Atr_Clear_Frame:GetChildren()}) do
			if child:GetObjectType() == "Button" then
				S:HandleButton(child)
			end
		end

    -- [Config: Shopping Lists]
        Atr_ShpList_Options_Frame:SetTemplate("Transparent")
        Atr_ShpList_Frame:SetTemplate("Transparent")
        Atr_ShpList_Edit_Frame:SetTemplate("Default")
        Atr_ShpList_Edit_Frame:SetBackdropColor(0, 0, 0, 0.8)
        Atr_ShpList_Edit_FrameScrollFrame:CreateBackdrop("Transparent")
        Atr_ShpList_Edit_TXTBOX_List:SetTemplate("Transparent")
        
        S:HandleButton(Atr_ShpList_NewButton)
        S:HandleButton(Atr_ShpList_DeleteButton)
        S:HandleButton(Atr_ShpList_EditButton)
        S:HandleButton(Atr_ShpList_RenameButton)
        S:HandleButton(Atr_ShpList_ImportButton)
        S:HandleButton(Atr_ShpList_ExportButton)
        S:HandleButton(Atr_ShpList_BTN_Save)
        S:HandleButton(Atr_ShpList_BTN_Cancel)
        S:HandleButton(Atr_ShpList_Import_BTN_Save)
end

if isAuctionatorPlus then 
	S:AddCallbackForAddon("Auctionator", "Auctionator", LoadAuctionatorv3Elements)
else
	S:AddCallbackForAddon("Auctionator", "Auctionator", LoadAuctionatorv2Elements)
end
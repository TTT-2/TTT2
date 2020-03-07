concommand.Add("vguitest", function()
	local Frame = vgui.Create("DFrameTTT2")
	Frame:SetSize(1100, 700)
	Frame:Center()
	Frame:SetTitle("help_title")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:ShowBackButton(false)
	Frame:MakePopup()
	Frame:SetSkin("ttt2_default")

	-- create a scroll panel
	local Scroll = vgui.Create("DScrollPanel", Frame) -- Create the Scroll panel
	Scroll:Dock(FILL)

	local List = vgui.Create("DIconLayout", Scroll)
	List:Dock(FILL)
	List:SetSpaceY(5) -- Sets the space in between the panels on the Y Axis by 5
	List:SetSpaceX(5) -- Sets the space in between the panels on the X Axis by 5

	for i = 1, 20 do
		local ListItem = List:Add("DMenuButtonTTT2")
		ListItem:SetSize((1100 - 10 - 30) / 3, 120)
		ListItem:SetTitle("A Menu Option")
		ListItem:SetDescription("Some Settings, Other Settings, More Settings, So Many Settings, Infinite Cool Stuff")
		ListItem:SetImage(Material("vgui/ttt/dynamic/roles/icon_inno"))
	end

	local ListLabel = List:Add( "DLabel" ) -- Add a label that will be the only panel on its row
	ListLabel.OwnLine = true -- The magic variable that specifies this item has its own line all for itself
	ListLabel:SetText( "Hello World!" )

	for i = 1, 5 do
		local ListItem = List:Add( "DPanel" )
		ListItem:SetSize( 80, 40 )
	end
end)

concommand.Add("vguitest2", function()
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 300, 500 )
	frame:Center()
	frame:MakePopup()

	local dtree  = vgui.Create( "DTree", frame )
	dtree:Dock( FILL )

	local node = dtree:AddNode( "Node One" )
	local node = dtree:AddNode( "Node Two" )
	local cnode = node:AddNode( "Node 2.1" )
	local cnode = node:AddNode( "Node 2.2" )
	local cnode = node:AddNode( "Node 2.3" )
	local cnode = node:AddNode( "Node 2.4" )
	local cnode = node:AddNode( "Node 2.5" )
	local gcnode = cnode:AddNode( "Node 2.5" )
	local cnode = node:AddNode( "Node 2.6" )
	local node = dtree:AddNode( "Node Three ( Maps Folder )" )
	node:MakeFolder( "maps", "GAME", true )
	local node = dtree:AddNode( "Node Four" )
end)

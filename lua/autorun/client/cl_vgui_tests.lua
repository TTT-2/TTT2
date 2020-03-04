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
	local Frame = vgui.Create( "DFrame" ) -- Create a Frame to contain everything.
	Frame:SetTitle( "DIconLayout Example" )
	Frame:SetSize(1100, 700)
	Frame:Center()
	Frame:MakePopup()

	local Scroll = vgui.Create( "DScrollPanel", Frame ) -- Create the Scroll panel
	Scroll:Dock( FILL )

	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL )
	List:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
	List:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5

	for i = 1, 20 do -- Make a loop to create a bunch of panels inside of the DIconLayout
		local ListItem = List:Add( "DPanel" ) -- Add DPanel to the DIconLayout
		ListItem:SetSize( 80, 40 ) -- Set the size of it
		-- You don't need to set the position, that is done automatically.
	end

	local ListLabel = List:Add( "DLabel" ) -- Add a label that will be the only panel on its row
	ListLabel.OwnLine = true -- The magic variable that specifies this item has its own line all for itself
	ListLabel:SetText( "Hello World!" )

	for i = 1, 5 do
		local ListItem = List:Add( "DPanel" )
		ListItem:SetSize( 80, 40 )
	end
end)

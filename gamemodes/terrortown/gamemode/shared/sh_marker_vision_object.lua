---
-- @author Mineotopia
-- @class MARKER_VISION_OBJECT

MARKER_VISION_OBJECT = {}
MARKER_VISION_OBJECT.data = {}

---
-- Sets the pass through data to the element.
-- @param any passThroughData The pass through data
-- @realm shared
function MARKER_VISION_OBJECT:SetPassThroughData(passThroughData)
	self.data.passThroughData = passThroughData
end

---
-- Gets the pass through data to the element.
-- @return any The pass through data
-- @realm shared
function MARKER_VISION_OBJECT:GetPassThroughData()
	return self.data.passThroughData
end

---
-- Sets the mark color to the element.
-- @param Color color The color
-- @realm shared
function MARKER_VISION_OBJECT:SetColor(color)
	self.data.color = color
end

---
-- Gets the mark color to the element.
-- @return Color The color
-- @realm shared
function MARKER_VISION_OBJECT:GetColor()
	return self.data.color
end

---
-- Sets the marked entity to the element.
-- @param Entity ent The marked entity
-- @realm shared
function MARKER_VISION_OBJECT:SetEnt(ent)
	self.data.ent = ent
end

---
-- Gets the marked entity to the element.
-- @return Entity The marked entity
-- @realm shared
function MARKER_VISION_OBJECT:GetEnt()
	return self.data.ent
end

---
-- Sets the unique identifier to the element.
-- @param string identifier The unique identifier
-- @realm shared
function MARKER_VISION_OBJECT:SetIdentifier(identifier)
	self.data.identifier = identifier
end

---
-- Gets the unique identifier to the element.
-- @return string The unique identifier
-- @realm shared
function MARKER_VISION_OBJECT:GetIdentifier()
	return self.data.identifier
end

---
-- Sets the mark owner to the element.
-- @param Entity owner The mark owner
-- @realm shared
function MARKER_VISION_OBJECT:SetOwner(owner)
	self.data.owner = owner
end

---
-- Gets the mark owner to the element.
-- @return Entity The mark owner
-- @realm shared
function MARKER_VISION_OBJECT:GetOwner()
	return self.data.owner
end

---
-- Sets the visible for flag to the element.
-- @param number visibleFor The visible for flag
-- @realm shared
function MARKER_VISION_OBJECT:SetVisibleFor(visibleFor)
	self.data.visibleFor = visibleFor
end

---
-- Gets the visible for flag to the element.
-- @return number The visible for flag
-- @realm shared
function MARKER_VISION_OBJECT:GetVisibleFor()
	return self.data.visibleFor
end

---
-- Gets the visible for flag as a language string to the element.
-- @return string The visible for flag as a language string
-- @realm shared
function MARKER_VISION_OBJECT:GetVisibleForTranslationKey()
	return "marker_vision_visible_for_" .. tostring(self:GetVisibleFor())
end

---
-- Checks if this element is the searched object defined by the unique
-- identifier and the entity that is marked.
-- @param Entity ent The entitiy that is possibly marked
-- @param string identifier The unique identifier
-- @return boolean Returns true if the element matches
-- @realm shared
function MARKER_VISION_OBJECT:IsObjectFor(ent, identifier)
	return self.data.ent == ent and self.data.identifier == identifier
end

---
-- Updates the relations of this marker vision element.
-- @note This does not sync it to the client, call @{MARKER_VISION_OBJECT:SyncToClients} to sync to client.
-- @param number|string|Player owner The owner of the wallhack that takes their ownership with them on
-- team change; can also be a team (string) or role (number) if it shouldn't be bound to a player
-- @param number visibleFor Visibility setting: `VISIBLE_FOR_PLAYER`, `VISIBLE_FOR_ROLE`, `VISIBLE_FOR_TEAM`,
-- `VISIBLE_FOR_ALL`
-- @realm shared
function MARKER_VISION_OBJECT:UpdateRelations(owner, visibleFor)
	-- this is done this way to support an UpdateRelations call on Role/Team change without
	-- the need to pass these values again
	self.data.owner = owner or self.data.owner
	self.data.visibleFor = visibleFor or self.data.visibleFor
end

---
-- Checks if the entity is valid and the identifier is set.
-- @return boolean Returns true if valid
-- @realm shared
function MARKER_VISION_OBJECT:IsValid()
	if not IsValid(self.data.ent) then
		return false
	end

	if not self.data.identifier or self.data.identifier == "" then
		return false
	end

	return true
end

if SERVER then
	---
	-- Syncs the marker vision element to the client that should receive it.
	-- @note The receipients should be set first with @{MARKER_VISION_OBJECT:UpdateRelations}.
	-- @note If the marker vision element was synced already, it is updated on the client.
	-- @param[opt] table receiverListOverwrite A table of players that should receive the update
	-- if not the automatic receipient selection should be used.
	-- @param[opt] any passThroughData Data that should be sent with this call as well
	-- @realm server
	function MARKER_VISION_OBJECT:SyncToClients(receiverListOverwrite, passThroughData)
		if not self.data.owner then return end

		if self.data.visibleFor == VISIBLE_FOR_PLAYER then
			self.receiverList = {self.data.owner}
		elseif self.data.visibleFor == VISIBLE_FOR_ROLE then
			if IsPlayer(self.data.owner) then
				self.receiverList = GetRoleFilter(self.data.owner:GetSubRole(), false)
			else
				-- handle static role
				self.receiverList = GetRoleFilter(self.data.owner, false)
			end
		elseif self.data.visibleFor == VISIBLE_FOR_TEAM then
			if IsPlayer(self.data.owner) then
				self.receiverList = GetTeamFilter(self.data.owner:GetTeam(), false, true)
			else
				-- handle static team
				self.receiverList = GetTeamFilter(self.data.owner, false, true)
			end
		else
			self.receiverList = nil
		end

		-- note: when VISIBLE_FOR_ALL is used, the receiver will be nil and
		-- therefore SendStream uses net.Broadcast

		-- if data was previously set, it should be removed first on the client
		if self.lastReceiverList then
			net.Start("ttt2_marker_vision_entity_removed")
			net.WriteEntity(self.data.ent)
			net.WriteString(self.data.identifier)
			net.Send(self.lastReceiverList)
		end

		self:SetPassThroughData(passThroughData)

		-- delay adding wallhack by a tick so that all possible removals are always done first
		timer.Simple(0, function()
			if not IsValid(self) then return end

			net.SendStream("ttt2_marker_vision_entity", self.data, receiverListOverwrite or self.receiverList)

			self:SetPassThroughData(nil)

			-- cache this, so we know where to remove the old data on update
			self.lastReceiverList = receiverListOverwrite or self.receiverList
		end)
	end
end

if CLIENT then
	net.ReceiveStream("ttt2_marker_vision_entity", function(streamData)
		-- handle existing data on the client, the existing one will be updated
		if IsValid(markerVision.Get(streamData.ent, streamData.identifier)) then
			markerVision.Remove(streamData.ent, streamData.identifier)
		end

		local mvObject = markerVision.Add(streamData.ent, streamData.identifier)
		mvObject:UpdateRelations(streamData.owner, streamData.visibleFor)
		mvObject:SetColor(streamData.color)
		mvObject:SetPassThroughData(streamData.passThroughData)

		-- add mark to entity
		if streamData.visibleFor == VISIBLE_FOR_ALL then
			streamData.color = streamData.color or TEAMS[TEAM_INNOCENT].color
		elseif streamData.visibleFor == VISIBLE_FOR_PLAYER then
			streamData.color = streamData.color or TEAMS[TEAM_NONE].color
		elseif streamData.visibleFor == VISIBLE_FOR_ROLE then
			streamData.color = streamData.color or LocalPlayer():GetRoleColor()
		else
			streamData.color = streamData.color or TEAMS[LocalPlayer():GetTeam()].color
		end

		marks.Add({streamData.ent}, streamData.color)
	end)

	net.Receive("ttt2_marker_vision_entity_removed", function()
		markerVision.Remove(net.ReadEntity(), net.ReadString())
	end)
end

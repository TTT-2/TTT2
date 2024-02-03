---
-- This class handles the syncing and tracking of markerVision elements
-- between the server and the client. Each markerVision element has its
-- own instance of this class that contains all the data.
-- @author Mineotopia
-- @class MARKER_VISION_ELEMENT

MARKER_VISION_ELEMENT = {}
MARKER_VISION_ELEMENT.data = {}

---
-- Sets the mark color to the element.
-- @param Color color The color
-- @realm shared
function MARKER_VISION_ELEMENT:SetColor(color)
	self.data.color = color
end

---
-- Gets the mark color to the element.
-- @return Color The color
-- @realm shared
function MARKER_VISION_ELEMENT:GetColor()
	return self.data.color
end

---
-- Sets the marked entity to the element.
-- @param Entity ent The marked entity
-- @realm shared
function MARKER_VISION_ELEMENT:SetEnt(ent)
	self.data.ent = ent
end

---
-- Gets the marked entity to the element.
-- @return Entity The marked entity
-- @realm shared
function MARKER_VISION_ELEMENT:GetEnt()
	return self.data.ent
end

---
-- Sets the unique identifier to the element.
-- @param string identifier The unique identifier
-- @realm shared
function MARKER_VISION_ELEMENT:SetIdentifier(identifier)
	self.data.identifier = identifier
end

---
-- Gets the unique identifier to the element.
-- @return string The unique identifier
-- @realm shared
function MARKER_VISION_ELEMENT:GetIdentifier()
	return self.data.identifier
end

---
-- Sets the mark owner to the element.
-- @param Entity owner The mark owner
-- @realm shared
function MARKER_VISION_ELEMENT:SetOwner(owner)
	self.data.owner = owner
end

---
-- Gets the mark owner to the element.
-- @return Entity The mark owner
-- @realm shared
function MARKER_VISION_ELEMENT:GetOwner()
	return self.data.owner
end

---
-- Sets the visible for flag to the element.
-- @param number visibleFor The visible for flag
-- @realm shared
function MARKER_VISION_ELEMENT:SetVisibleFor(visibleFor)
	self.data.visibleFor = visibleFor
end

---
-- Gets the visible for flag to the element.
-- @return number The visible for flag
-- @realm shared
function MARKER_VISION_ELEMENT:GetVisibleFor()
	return self.data.visibleFor
end

---
-- Gets the visible for flag as a language string to the element.
-- @return string The visible for flag as a language string
-- @realm shared
function MARKER_VISION_ELEMENT:GetVisibleForTranslationKey()
	return "marker_vision_visible_for_" .. tostring(self:GetVisibleFor())
end

---
-- Checks if this element is the searched object defined by the unique
-- identifier and the entity that is marked.
-- @param Entity ent The entitiy that is possibly marked
-- @param string identifier The unique identifier
-- @return boolean Returns true if the element matches
-- @realm shared
function MARKER_VISION_ELEMENT:IsObjectFor(ent, identifier)
	return self.data.ent == ent and self.data.identifier == identifier
end

---
-- Checks if the entity is valid and the identifier is set.
-- @return boolean Returns true if valid
-- @realm shared
function MARKER_VISION_ELEMENT:IsValid()
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
	-- @note The receipients should be set first with @{MARKER_VISION_ELEMENT:SetOwner} and
	-- @{MARKER_VISION_ELEMENT:SetVisibleFor}.
	-- @note If the marker vision element was synced already, it is updated on the client.
	-- @param[opt] table receiverListOverwrite A table of players that should receive the update
	-- if not the automatic receipient selection should be used.
	-- @realm server
	function MARKER_VISION_ELEMENT:SyncToClients(receiverListOverwrite)
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

		self.receiverList = receiverListOverwrite or self.receiverList

		-- If data was previously set, it should be removed first on the client. This is a
		-- simple solution to a complex problem where the marks color has to be updated or
		-- removed on the client before updating it.
		-- A more in depth solution that reduces network traffic would be possible, but as
		-- this won't be called that often anyway, this shouldn't be an issue
		if self.lastReceiverList then
			net.Start("ttt2_marker_vision_entity_removed")
			net.WriteEntity(self.data.ent)
			net.WriteString(self.data.identifier)
			net.Send(self.lastReceiverList)
		end

		-- delay adding wallhack by a tick so that all possible removals are always done first
		timer.Simple(0, function()
			if not IsValid(self) then return end

			net.SendStream("ttt2_marker_vision_entity", self.data, self.receiverList)

			-- cache this, so we know where to remove the old data on update
			self.lastReceiverList = self.receiverList
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
		mvObject:SetOwner(streamData.owner)
		mvObject:SetVisibleFor(streamData.visibleFor)
		mvObject:SetColor(streamData.color)

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

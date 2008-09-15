local parent = debugstack():match[[AddOns\(.-)\]]
local global = GetAddOnMetadata(parent, 'X-oUF')
assert(global, 'X-oUF needs to be defined in the parent add-on.')
local oUF = _G[global]

function oUF:UNIT_HAPPINESS(event, unit)
	if(self.unit ~= unit) then return end

	if(event == 'UNIT_HAPPINESS') then
		if(self:IsEventRegistered'UNIT_MAXHEALTH') then self:UNIT_MAXHEALTH(event, unit) end
		if(self:IsEventRegistered'UNIT_MAXMANA') then self:UNIT_MAXMANA(event, unit) end
	end

	if(self.Happiness) then
		local happiness = GetPetHappiness()
		local hunterPet = select(2, HasPetUI())

		if(not (happiness or hunterPet)) then
			return self.Happiness:Hide()
		end

		self.Happiness:Show()
		if(happiness == 1) then
			self.Happiness:SetTexCoord(0.375, 0.5625, 0, 0.359375)
		elseif(happiness == 2) then
			self.Happiness:SetTexCoord(0.1875, 0.375, 0, 0.359375)
		elseif(happiness == 3) then
			self.Happiness:SetTexCoord(0, 0.1875, 0, 0.359375)
		end

		if(self.PostUpdateHappiness) then self:PostUpdateHappiness(event, unit, happiness) end
	end
end

table.insert(oUF.subTypes, function(self)
	local happiness = self.Happiness
	if(happiness) then
		self:RegisterEvent"UNIT_HAPPINESS"

		if(happiness:IsObjectType"Texture" and not happiness:GetTexture()) then
			happiness:SetTexture[[Interface\PetPaperDollFrame\UI-PetHappiness]]
		end
	end
end)
oUF:RegisterSubTypeMapping"UNIT_HAPPINESS"

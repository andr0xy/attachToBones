local AttachementsTable = {};

local m_sin = math.sin;
local m_cos = math.cos;
local elm = isElement;
local tonr = tonumber;
local _getElementBoneMatrix = getElementBoneMatrix;
local _setElementMatrix = setElementMatrix;
local _isElementOnScreen = isElementOnScreen;
local _setElementPosition = setElementPosition;
local boneMat, rotMat, finalMatrix = {}, {}, {};
local notOnScrenElements = {};

local boneMatOne = false;
local boneMatTwo = false;
local boneMatTree = false;
local boneMatFor = false;
local boneMatOneOne = false;
local boneMatOneTwo = false;
local boneMatOneTree = false;
local boneMatTwoOne = false;
local boneMatTwoTwo = false;
local boneMatTwoTree = false;
local boneMatTreeOne = false;
local boneMatTreeTwo = false;
local boneMatTreeTree = false;
local boneMatForOne = false;
local boneMatForTwo = false;
local boneMatForTree = false;
local rotMatOne = false;
local rotMatTwo = false;
local rotMatTree = false;
local rotMatOneOne = false;
local rotMatOneTwo = false;
local rotMatOneTree = false;
local rotMatTwoOne = false;
local rotMatTwoTwo = false;
local rotMatTwoTree = false;
local rotMatTreeOne = false;
local rotMatTreeTwo = false;
local rotMatTreeTree = false;
local FOR = false;
local FIVE = false;
local SIX = false;

addEvent("sync_attachements", true);
addEvent("sync_detachements", true);
addEvent("sync_newcomeattachements", true);
addEvent("sync_pos_attachements", true);

local function calculateMatrix(orx, ory, orz)
	if tonr(orx) and tonr(ory) and tonr(orz) then
		local sroll, croll, spitch, cpitch, syaw, cyaw = m_sin(m_rad(orz)), m_cos(m_rad(orz)), m_sin(m_rad(ory)), m_cos(m_rad(ory)), m_sin(m_rad(orx)), m_cos(m_rad(orx));
		local rotMat = {
			{sroll * spitch * syaw + croll * cyaw, sroll * cpitch, sroll * spitch * cyaw - croll * syaw},
			{croll * spitch * syaw - sroll * cyaw, croll * cpitch, croll * spitch * cyaw + sroll * syaw},
			{cpitch * syaw, -spitch, cpitch * cyaw}
		};
		return rotMat;
	end
	return false;
end

addEventHandler("sync_attachements", root, function(element, data)
	if elm(element) and data then
		AttachementsTable[element] = data;
	end
end);

addEventHandler("sync_detachements", root, function(elm)
	if AttachementsTable[elm] then
		AttachementsTable[elm] = nil;
	end
end);

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("sync_newcomeplayer", localPlayer);
end);

addEventHandler("sync_newcomeattachements", resourceRoot, function(theTable)
	if type(theTable) == "table" then
		AttachementsTable = {};
		AttachementsTable = theTable;
	end
end);

addEventHandler("sync_pos_attachements", resourceRoot, function(element, theTable)
	if type(theTable) == "table" then
		AttachementsTable[element] = theTable;
	end
end);

addEventHandler("onClientPedsProcessed", root, function()
	for element,data in next, AttachementsTable do
		local ped = data[1];
		if _isElementOnScreen(ped) then
			notOnScrenElements[element] = false;
			boneMat = _getElementBoneMatrix(ped, data[2]);
			rotMat = data[6];
			boneMatOne = boneMat[1];
			boneMatTwo = boneMat[2];
			boneMatTree = boneMat[3];
			boneMatFor = boneMat[4];
			boneMatOneOne = boneMatOne[1];
			boneMatOneTwo = boneMatOne[2];
			boneMatOneTree = boneMatOne[3];
			boneMatTwoOne = boneMatTwo[1];
			boneMatTwoTwo = boneMatTwo[2];
			boneMatTwoTree = boneMatTwo[3];
			boneMatTreeOne = boneMatTree[1];
			boneMatTreeTwo = boneMatTree[2];
			boneMatTreeTree = boneMatTree[3];
			boneMatForOne = boneMatFor[1];
			boneMatForTwo = boneMatFor[2];
			boneMatForTree = boneMatFor[3];
			rotMatOne = rotMat[1];
			rotMatTwo = rotMat[2];
			rotMatTree = rotMat[3];
			rotMatOneOne = rotMatOne[1];
			rotMatOneTwo = rotMatOne[2];
			rotMatOneTree = rotMatOne[3];
			rotMatTwoOne = rotMatTwo[1];
			rotMatTwoTwo = rotMatTwo[2];
			rotMatTwoTree = rotMatTwo[3];
			rotMatTreeOne = rotMatTree[1];
			rotMatTreeTwo = rotMatTree[2];
			rotMatTreeTree = rotMatTree[3];
			TREE = data[3];
			FOR = data[4];
			FIVE = data[5];
			finalMatrix = {
				{boneMatTwoOne * rotMatOneTwo + boneMatOneOne * rotMatOneOne + rotMatOneTree * boneMatTreeOne,
				boneMatTreeTwo * rotMatOneTree + boneMatOneTwo * rotMatOneOne + boneMatTwoTwo * rotMatOneTwo,
				boneMatTwoTree * rotMatOneTwo + boneMatTreeTree * rotMatOneTree + rotMatOneOne * boneMatOneTree, 0},
				{rotMatTwoTree * boneMatTreeOne + boneMatTwoOne * rotMatTwoTwo + rotMatTwoOne * boneMatOneOne,
				boneMatTreeTwo * rotMatTwoTree + boneMatTwoTwo * rotMatTwoTwo + boneMatOneTwo * rotMatTwoOne,
				rotMatTwoOne * boneMatOneTree + boneMatTreeTree * rotMatTwoTree + boneMatTwoTree * rotMatTwoTwo, 0},
				{boneMatTwoOne * rotMatTreeTwo + rotMatTreeTree * boneMatTreeOne + rotMatTreeOne * boneMatOneOne,
				boneMatTreeTwo * rotMatTreeTree + boneMatTwoTwo * rotMatTreeTwo + rotMatTreeOne * boneMatOneTwo,
				rotMatTreeOne * boneMatOneTree + boneMatTreeTree * rotMatTreeTree + boneMatTwoTree * rotMatTreeTwo, 0},
				{TREE * boneMatOneOne + FOR * boneMatTwoOne + FIVE * boneMatTreeOne + boneMatForOne,
				TREE * boneMatOneTwo + FOR * boneMatTwoTwo + FIVE * boneMatTreeTwo + boneMatForTwo,
				TREE * boneMatOneTree + FOR * boneMatTwoTree + FIVE * boneMatTreeTree + boneMatForTree, 1}
			};
			_setElementMatrix(element, finalMatrix);
		else
			if not notOnScrenElements[element] then
				_setElementPosition(element, 0, 0, -10000);
				notOnScrenElements[element] = true;
			end
		end
	end
end);

addEventHandler("onClientElementDestroy", root, function()
	if AttachementsTable[source] then
		AttachementsTable[source] = nil;
	end
end);

function attachElementToBone(element, ped, bone, offx, offy, offz, offrx, offry, offrz)
	if elm(element) and elm(ped) and tonr(bone) then
		if isElementAttachedToBone(element) then return false; end
		local offrx = offrx or 0;
		local offry = offry or 0;
		local offrz = offrz or 0;
		local rotMat = calculateMatrix(offrx, offry, offrz);
		local table = {ped, bone, tonr(offx) or 0, tonr(offy) or 0, tonr(offz) or 0, rotMat};
		setElementCollisionsEnabled(element, false);
		AttachementsTable[element] = table;
		return true;
	end
	return false;
end

function detachElementFromBone(element)
	if elm(element) then
		if AttachementsTable[element] then
			AttachementsTable[element] = nil;
			return true;
		end
	end
	return false;
end

function isElementAttachedToBone(element)
	if elm(element) then
		if AttachementsTable[element] then
			return true;
		end
	end
	return false;
end

function getElementBoneAttachmentDetails(element)
	if elm(element) then
		if AttachementsTable[element] then
			return AttachementsTable[element];
		end
	end
	return false;
end

function setElementBonePositionOffset(element, offsetx, offsety, offsetz)
	if elm(element) then
		local elmT = AttachementsTable[element] or nil;
		if elmT then
			local ped = elmT[1];
			local bone = elmT[2];
			local rotM = elmT[6];
			local tableSynch = {ped, bone, offsetx, offsety, offsetz, rotM};
			AttachementsTable[element] = tableSynch;
			return true;
		end
	end
	return false;
end

function setElementBoneRotationOffset(element, offsetrx, offsetry, offsetrz)
	if elm(element) then
		local elmT = AttachementsTable[element] or nil;
		if elmT then
			local ped = elmT[1];
			local bone = elmT[2];
			local ox = elmT[3];
			local oy = elmT[4];
			local oz = elmT[5];
			local rotm = calculateMatrix(offsetrx, offsetry, offsetrz);
			local tableSynch = {ped, bone, ox, oy, oz, rotm};
			AttachementsTable[element] = tableSynch;
			return true;
		end
	end
	return false;
end
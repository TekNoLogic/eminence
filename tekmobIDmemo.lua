
local ids = LibStub:NewLibrary("tekmobIDmemo", 1)
if not ids then return end

setmetatable(ids, {
	__index = function(t,i)
		if type(i) ~= "string" then return end
		guid = tonumber((i):sub(-12, -7), 16)
		t[i] = guid
		return guid
	end
})

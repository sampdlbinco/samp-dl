
local files = {
	{ "casino_lod.txd.pcrypt", 4105 },
	{ "casino.txd.pcrypt", 4101 },
	{ "casino_road1.dff.pcrypt", 4168 },
	{ "casino_road2.dff.pcrypt", 6128 },
	{ "casino.dff.pcrypt", 4101 },
	{ "casino_alpha2.dff.pcrypt", 4102 },
	{ "casino_lod.dff.pcrypt", 4105 },
	{ "casino_road1.col.pcrypt", 4168 },
	{ "casino_road2.col.pcrypt", 6128 },
	{ "casino.col.pcrypt", 4101 },
}


local cor = coroutine.create(function()
    for i = 1, #files do
        local file  = files[i][1]
        local model = files[i][2]

        pDecrypt(file, function(data)
            loadModel(file, data, model)
        end)
        coroutine.yield()
    end

    files = nil
    collectgarbage()
end)

function loadModel(file, data, model)
    local ext = file:match("^.+(%..+)%..+$")

    if ext == ".dff" then
        engineReplaceModel(engineLoadDFF(data), model)
    elseif ext == ".txd" then
        engineImportTXD(engineLoadTXD(data), model)
    elseif ext == ".col" then
        engineReplaceCOL(engineLoadCOL(data), model)
    end

    coroutine.resume(cor)
end

coroutine.resume(cor)

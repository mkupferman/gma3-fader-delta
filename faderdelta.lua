-- Increment/decrement a GrandMA3 executor fader by specified percentage
-- Optionally, also revert the fader back to its original value after a delay

local json = require('json')
local function usage()
    Echo("Usage: call plugin <num> '{<json args>}'")
    Echo("       Where args are 'exec', 'delta',")
    Echo("       'page'=1, 'revert'=false, 'delay'=0.0")
    Echo("Example: call plugin 1 '{\"exec\": 113, \"delta\": -10}'")
end

local function main(handle, params)
    -- params example: '{"exec": 113, "delta": 10}'
    -- optional params: '{"page": 2, "revert": true, "delay": 0.5}'
    if params then
        local args = json.decode(params)
        if args["exec"] and args["delta"] then
            local exec = args["exec"] - 100
            local delta = args["delta"]
            local page = 1

            if args["page"] then
                page = args["page"]
            end

            local execObj = DataPool().Pages[page][exec]
            local origVal = execObj:GetFader({})
            local newVal = origVal + delta

            local faderValue = {}
            faderValue.value = newVal
            execObj:SetFader(faderValue)

            if args["revert"] == true then
                if args["delay"] then
                    coroutine.yield(args["delay"])
                end
                faderValue.value = origVal
                execObj:SetFader(faderValue)
            end
        else
            usage()
        end
    else
        usage()
    end
end
return main

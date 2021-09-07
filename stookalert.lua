-- StookAlert. 
-- The stookalert sensor platform queries the RIVM Stookalert API for unfavorable weather conditions or poor air quality. 
-- With a Stookalert, the RIVM calls on people not to burn wood. 
-- This can prevent health problems in people in the area.

local Provincie = 'Noord-Brabant' --  Set Provincie to correct value: Drenthe, Flevoland, Friesland, Gelderland, Groningen, Limburg, Noord-Brabant, Noord-Holland, Overijssel, Utrecht, Zeeland or Zuid-Holland
local Alertidx = 359 -- Change to your idx for the Virtual Alert sensor you have created for this script

-- no changes needed below this section

return {
	on = {
		timer = {
			'at 12:15' -- RIVM updates the json at 12:00 hrs, running it between 0:00 and 12:00 results in an error.
		},
		httpResponses = {
			'triggerSA' -- must match with the callback passed to the openURL command
		}
	},
	logging = {
		level = domoticz.LOG_INFO,
		marker = 'StookAlert',
	},
	execute = function(domoticz, item)

		if (item.isTimer) then
		    local Currentdate = domoticz.time.dateToDate(tostring(domoticz.time.rawDate),'yyyy-mm-dd', 'yyyymmdd')
		    domoticz.openURL({
				url = 'https://www.rivm.nl/media/lml/stookalert/stookalert_' .. Currentdate .. '.json',
				method = 'GET',
				callback = 'triggerSA', -- see httpResponses above.
			})
		end

		if (item.isHTTPResponse) then

			if (item.ok) then
				if (item.isJSON) then

					local result_table = item.json
					local tc = #result_table
					
					for i = 1, tc do
					    if result_table[i].naam == Provincie then
                            StookAlertValue = result_table[i].waarde
                        end
                    end
					domoticz.log('StookAlertValue = ' .. StookAlertValue, domoticz.LOG_INFO)
					
					if StookAlertValue == 0 then
					    level = domoticz.ALERTLEVEL_GREEN 	-- domoticz.ALERTLEVEL_GREY, ALERTLEVEL_GREEN, ALERTLEVEL_YELLOW, ALERTLEVEL_ORANGE, ALERTLEVEL_RED
					    AlertText = 'Geen Stookalert'	
					else
					    level = domoticz.ALERTLEVEL_RED 	
					    AlertText = 'Stookalert!'
                    end
					-- update some device in Domoticz
					domoticz.devices(Alertidx).updateAlertSensor(level, AlertText)
				end
			else
				domoticz.log('There was a problem handling the request' .. url, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end

		end

	end
}

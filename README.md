# Domoticz-dzVents-Stookalert

The stookalert sensor platform queries the RIVM Stookalert API for unfavorable weather conditions or poor air quality. 
With a Stookalert, the RIVM calls on people not to burn wood. 
This can prevent health problems in people in the area.

You can copy and paste the script in Domoticz with Setup - More Options - Events. 
Create a new dzvents script with trigger HTTP and paste the contents over the template.
Create a dummy Alert Sensor, it will appear in the utility tab.
Modify the script with your province and the idx of the Alert Sensor.

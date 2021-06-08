package warning_lights with SPARK_Mode is
   
   -- define light status
   type LightStatus is (On, Off);
   
   -- define light names
   type LightName is (Low_Fuel, Low_Alt, High_Alt, Low_Speed, High_Speed, Low_Rpm, High_Rpm);
   
   -- create a generic Warning Light
   type WarningLight is tagged record
      name : LightName;
      status : LightStatus;
   end record;
   
   -- create an array of warning lights
   type WarningLights_Idx is range 0..6;
   type WarningLights is array (WarningLights_Idx) of WarningLight;
   
   -- funciton to get the lights from another file
   function GetWarningLights return WarningLights;
   
   -- Turn lights on and off
   procedure TurnOnWarningLight(wl : in out WarningLight) with
     Post => LightOn(wl);
   
   procedure TurnOffWarningLight(wl : in out WarningLight) with
     Post => LightOff(wl);
   
   function LightOn(wl : in WarningLight) return Boolean is
     (wl.status = On);
   
   function LightOff(wl : in WarningLight) return Boolean is
      (wl.status = Off);

end warning_lights;

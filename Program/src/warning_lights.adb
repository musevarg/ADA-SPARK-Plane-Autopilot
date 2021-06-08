with Ada.Text_IO;

package body warning_lights with SPARK_Mode is

   -- Procedure to allow printing outputs to the console
   -- while still using SPARK_Mode in other procedures
   procedure Put_Line (Item : String) with
      Global => null;
   procedure Put_Line (Item : String) with
      SPARK_Mode => Off
   is
   begin
      Ada.Text_IO.Put_Line (Item);
   end Put_Line;
   -- End of output procedure

   
   function GetWarningLights return WarningLights is      
      wl : WarningLights :=
        (0 => (Low_Fuel, Off),
         1 => (Low_Alt, Off),
         2 => (High_Alt, Off),
         3 => (Low_Speed, Off),
         4 => (High_Speed, Off),
         5 => (Low_Rpm, Off),
         6 => (High_Rpm, Off));
   begin
      --for Z in wl'Range loop
      --   TurnOffWarningLight(wl(Z));
      --end loop;
      return wl;
   end GetWarningLights;
   
   
   procedure TurnOnWarningLight(wl : in out WarningLight)
   is
   begin
      if wl.status = Off then
         wl.status := On;
         Put_Line(wl.name'Image & " WARNING LIGHT: " & wl.status'Image);
      end if;
   end TurnOnWarningLight;
   
   procedure TurnOffWarningLight(wl : in out WarningLight)
   is
   begin
      if wl.status = On then
         wl.status := Off;
         Put_Line(wl.name'Image & " WARNING LIGHT: " & wl.status'Image);
      end if;
   end TurnOffWarningLight;
   
   
end warning_lights;

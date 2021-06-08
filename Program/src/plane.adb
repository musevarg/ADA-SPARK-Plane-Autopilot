with Ada.Text_IO;

package body plane with SPARK_Mode is
   
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
   
   
   -- Get plane ready for takeoff
   procedure GetReadyForTakeOff(p : in out Plane)
   is
   begin
      Put_Line("Getting ready for takeoff.");
      delay 1.0;
      if not DoorsClosed(p.all_doors) then
         CloseDoors(p.all_doors);
      end if;
      if not DoorsLocked(p.all_doors) then
         LockDoors(p.all_doors);
      end if;
      if p.current_fuel < 36000 then
         TurnOnWarningLight(p.all_warning_lights(0));
         FillTank(p.current_fuel);
         TurnOffWarningLight(p.all_warning_lights(0));
      end if;
      if EnginesOff(p.all_engines) then
         TurnOnEngines(p.all_engines);
      end if;
      p.current_status := Ready_For_Takeoff;
   end GetReadyForTakeOff;
   
   
   -- Fill tank if necessary
   procedure FillTank(f : in out Fuel)
   is
      Lim : Fuel := 40000;
   begin
      if (f < Lim) then
         Put_Line("Filling tank...");
         while f < Lim loop
            f := f + 1000;
            Put_Line("Fuel level: " & f'Image & " Gal");
            delay 0.3;
         end loop;
      end if;
      Put_Line("Tank refilled.");
   end FillTank;
   
   
   
   -- Takeoff
   procedure TakeOff(p : in out Plane)
   is
   begin
      if DoorsLocked(p.all_doors) then
         p.current_status := Takeoff;
         Put_Line("TAKING OFF");
         ChangeSpeed(p, 160);
         ChangeAltitude(p, 10000);
         p.current_status := Flying;
      else
         GetReadyForTakeOff(p);
         TakeOff(p);
      end if;  
      if p.current_speed = 0 or p.current_altitude = 0 then
         GetReadyForTakeOff(p);
         TakeOff(p);
      end if;
   end TakeOff;
       
   
   
   -- Normal Flight Mode
   procedure FlightMode(p : in out Plane; s : in out Airspeed; a : in out Altitude)
   is
   begin
               
      ChangeSpeed(p, s/2);
      ChangeAltitude(p, a/2);
      ChangeSpeed(p, s);
      ChangeAltitude(p, a);
      
      if not CorrectSpeed(s) then
         Put_Line("AUTOPILOT CORRECTING AIRSPEED");
         s := 560;
         ChangeSpeed(p, s);
      end if;
      
      if not CorrectAltitude(a) then
         Put_Line("AUTOPILOT CORRECTING ALTITUDE");
         a := 36000;
         ChangeAltitude(p, a);
      end if;
      
      p.current_status := Flying;
      
   end FlightMode;
   
   
   
   -- Landing mode
   procedure Landing(p : in out Plane)
   is
   begin
      p.current_status := Landing;
      ChangeAltitude(p, 20000);
      ChangeSpeed(p, 300);
      ChangeAltitude(p, 6000);
      ChangeSpeed(p, 190);
      ChangeAltitude(p, 900);
      ChangeSpeed(p, 150);
      ChangeAltitude(p, 0);
      ChangeSpeed(p, 0);
      if (p.current_speed /= 0 or p.current_altitude /=0) then
         p.current_altitude := 0;
         p.current_speed := 0;
      end if;
      p.current_status := Landed;
      Put_Line("PLANE HAS LANDED.");
   end Landing;
   
   
   -- Landed
   procedure Landed (p : in out Plane)
   is
   begin
      if EnginesOn(p.all_engines) then
         TurnOffEngines(p.all_engines);
      end if;      
      delay 0.5;
      if (DoorsLocked(p.all_doors)) then
         UnlockDoors(p.all_doors);
      end if;
      delay 0.5;
      if (DoorsClosed(p.all_doors)) then
         OpenDoors(p.all_doors);
      end if;
      
      if not DoorsOpened(p.all_doors) then
         OpenDoors(p.all_doors);
      end if;
      
   end Landed;
      
  
   -- Towed mode
   procedure Towed(p : in out Plane)
   is
   begin
      if EnginesOn(p.all_engines) then
         TurnOffEngines(p.all_engines);
      end if;
      if not DoorsClosed(p.all_doors) then
         CloseDoors(p.all_doors);
      end if;
      p.current_status := Towed;
      
      Put_Line("Plane is being towed.");
   end Towed;
        
   
   
   -- Change Speed
   procedure ChangeSpeed(p : in out Plane; target_speed : in Airspeed)
   is
      speed : Airspeed := p.current_speed;
   begin
      if speed < target_speed then
         while speed < target_speed loop
            Accelerate(p.all_engines);
            if p.all_engines(0).rpm > 2800 then TurnOnWarningLight(p.all_warning_lights(6)); else TurnOffWarningLight(p.all_warning_lights(6)); end if;
            if speed + 40 > Airspeed'Last then
               speed := target_speed;
            else
               speed := speed + 40;
            end if;
            Put_Line("Speed: " & speed'Image & " mph");
            if speed > 600 and p.current_status = Flying then TurnOnWarningLight(p.all_warning_lights(3)); else TurnOffWarningLight(p.all_warning_lights(3)); end if;
            delay 0.2;
         end loop;
         p.current_speed := target_speed;
      
      else
         while speed > target_speed loop
            Decelerate(p.all_engines);
            if p.all_engines(0).rpm < 2200 and p.current_status = Flying then TurnOnWarningLight(p.all_warning_lights(5)); else TurnOffWarningLight(p.all_warning_lights(5)); end if;
            if speed - 40 < Airspeed'First then 
               speed := target_speed; 
            else
               speed := speed - 40;
            end if;
            Put_Line("Speed: " & speed'Image & " mph");
            if speed < 500 and p.current_status = Flying then TurnOnWarningLight(p.all_warning_lights(4)); else TurnOffWarningLight(p.all_warning_lights(4)); end if;
            delay 0.2;
         end loop;
         p.current_speed := target_speed;
      end if;
      
      if p.current_status = Flying and p.all_engines(0).rpm > 2800 then
         Put_Line("AUTOPILOT SLOWING DOWN ENGINES");
         while p.all_engines(0).rpm > 2500 loop
            Decelerate(p.all_engines);
         end loop;
      end if;
      
      if p.current_status = Flying and p.all_engines(0).rpm < 2200 then
         Put_Line("AUTOPILOT ACCELERATING ENGINES");
         while p.all_engines(0).rpm < 2300 loop
            Accelerate(p.all_engines);
         end loop;
      end if;
      
      
      
   end ChangeSpeed;
   
   -- Change altitude
   procedure ChangeAltitude(p : in out Plane; target_alt : in Altitude)
   is
      alt : Altitude := p.current_altitude;
   begin
      if alt < target_alt then
         while alt < target_alt loop
            if alt + 400 > Altitude'Last then
               alt := target_alt;
            else
               alt := alt + 400;
            end if;
            p.current_altitude := alt;
            Put_Line("Altitude: " & alt'Image & " ft");
            ToggleLandingGear(p);
            if alt > 40000 and p.current_status = Flying then TurnOnWarningLight(p.all_warning_lights(2)); else TurnOffWarningLight(p.all_warning_lights(2)); end if;
            if alt > 30000 and p.current_status = Flying then TurnOffWarningLight(p.all_warning_lights(1)); end if;
            delay 0.2;
         end loop;
         p.current_altitude := target_alt;
      
      else
         while alt > target_alt loop
            if alt - 400 < Altitude'First then 
               alt := target_alt; 
            else
               alt := alt - 400;
            end if;
            p.current_altitude := alt;
            Put_Line("Altitude: " & alt'Image & " ft");
            ToggleLandingGear(p);
            if alt < 30000 and p.current_status = Flying then TurnOnWarningLight(p.all_warning_lights(1)); else TurnOffWarningLight(p.all_warning_lights(1)); end if;
            if alt < 40000 and p.current_status = Flying then TurnOffWarningLight(p.all_warning_lights(2)); end if;
            delay 0.2;
         end loop;
         p.current_altitude := target_alt;
      end if;
      
   end ChangeAltitude;
   
   -- Get landing gear in or out
   procedure ToggleLandingGear(p : in out Plane)
   is
   begin
      if p.current_altitude <= 1000 then
         if p.landing_gear /= Lowered then
            p.landing_gear := Lowered;
            Put_Line("Landing gear lowered");
         end if;
      else
         if p.landing_gear /= Retracted then
            p.landing_gear := Retracted;
            Put_Line("Landing gear retracted");
         end if;
      end if;
   end ToggleLandingGear;
   
   -- Warning Lights
   procedure WarningLights(p : in out Plane)
   is
   begin
      
      if p.current_fuel < 36000 and p.current_status = Landed and p.all_warning_lights(0).status = Off then
         TurnOnWarningLight(p.all_warning_lights(0));
      else
         TurnOffWarningLight(p.all_warning_lights(0));
      end if;
      
      if p.current_altitude < 30000 and p.current_status = Flying and p.all_warning_lights(1).status = Off then
         TurnOnWarningLight(p.all_warning_lights(1));
      else
         TurnOffWarningLight(p.all_warning_lights(1));
      end if;
      
      if p.current_altitude > 40000 and p.current_status = Flying and p.all_warning_lights(2).status = Off then
         TurnOnWarningLight(p.all_warning_lights(2));
      else
         TurnOffWarningLight(p.all_warning_lights(2));
      end if;
      
      if p.current_speed < 500 and p.current_status = Flying and p.all_warning_lights(3).status = Off then
         TurnOnWarningLight(p.all_warning_lights(3));
      else
         TurnOffWarningLight(p.all_warning_lights(3));
      end if;
      
      if p.current_speed > 600 and p.current_status = Flying and p.all_warning_lights(4).status = Off then
         TurnOnWarningLight(p.all_warning_lights(4));
      else
         TurnOffWarningLight(p.all_warning_lights(4));
      end if;
      
      if (p.all_engines(0).rpm < 2200 and p.all_engines(1).rpm < 2200) and (p.all_engines(0).status = On and p.all_engines(1).status = On) and p.all_warning_lights(5).status = Off then
         TurnOnWarningLight(p.all_warning_lights(5));
      else
         TurnOffWarningLight(p.all_warning_lights(5));
      end if;
      
      if (p.all_engines(0).rpm > 2800 and p.all_engines(1).rpm > 2800) and (p.all_engines(0).status = On and p.all_engines(1).status = On) and p.all_warning_lights(6).status = Off then
         TurnOnWarningLight(p.all_warning_lights(6));
      else
         TurnOffWarningLight(p.all_warning_lights(6));
      end if;
      
   end WarningLights;
      
      
end plane;

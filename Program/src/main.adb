with Ada.Text_IO; use Ada.Text_IO;
with plane; use plane;

procedure Main is

   -- Define a variable for keyboard interrupt
   S : String(1..10); Last : Integer;

   -- Create instance of plane
   MyPlane : plane.Plane;

   speed : Airspeed := 560;
   alt : Altitude := 42000;

   -- Create procedure to return information to the console
   procedure InformPilot is

   begin
      Put_Line("");
      Put_Line("Current Status: " & MyPlane.current_status'Image);
      Put_Line("Current Altitude: " & MyPlane.current_altitude'Image & " ft");
      Put_Line("Current Speed: " & MyPlane.current_speed'Image & " mph");
      Put_Line("Current Fuel: " & MyPlane.current_fuel'Image & " Gal");
      Put_Line("Landing Gear: " & MyPlane.landing_gear'Image);
      Put_Line("Engine Left: " & MyPlane.all_engines(0).status'Image & " - Engine Right: " & MyPlane.all_engines(1).status'Image);
   end InformPilot;

-- Run main
begin

   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   GetReadyForTakeOff(MyPlane);
   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   TakeOff(MyPlane);
   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   FlightMode(MyPlane, speed, alt);
   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   Landing(MyPlane);
   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   Landed(MyPlane);
   --InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

   Towed(MyPlane);
   InformPilot;
   Put_Line("Press enter key to continue...");
   Get_Line(S, Last);

end Main;

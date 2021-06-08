with Ada.Text_IO;

package body plane_engines with SPARK_Mode is

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
   
   -- Create instance of engines
   function GetEngines return Engines is      
      engine_statuses : Engines :=
        (0 => (On, 0),
         1 => (On, 0));
   begin
      TurnOffEngines(engine_statuses);
      return engine_statuses;
   end GetEngines;
   
   -- turn engines on and off
   procedure TurnOnEngines(e : in out Engines)
   is
   begin
      e(0).status := On;
      e(0).rpm := 2200;
      e(1).status := On;
      e(1).rpm := 2200;
      Put_Line("Engines are on.");
   end TurnOnEngines;
   
   procedure TurnOffEngines(e : in out Engines)
   is
   begin
      e(0).status := Off;
      e(0).rpm := 0;
      e(1).status := Off;
      e(1).rpm := 0;
      Put_Line("Engines are off.");
   end TurnOffEngines;
   
   
   procedure Accelerate(e : in out Engines)
   is
   begin
      if e(0).rpm < 2800 and e(1).rpm < 2800 then
         e(0).rpm := e(0).rpm + 100;
         e(1).rpm := e(1).rpm + 100;
         Put_Line("Engine Left RPM: " & e(0).rpm'Image & " - Engine Right RPM: " & e(1).rpm'Image);
      end if;
   end Accelerate;
   
   
   procedure Decelerate(e : in out Engines)
   is
   begin
      if e(0).rpm > 2200 and e(1).rpm > 2200 then
         e(0).rpm := e(0).rpm - 100;
         e(1).rpm := e(1).rpm - 100;
         Put_Line("Engine Left RPM: " & e(0).rpm'Image & " - Engine Right RPM: " & e(1).rpm'Image);
      end if;
   end Decelerate;
      

end plane_engines;

package plane_engines with SPARK_Mode is

   -- define engine status
   type EngineStatus is (On, Off);
  
   -- define RPM range
   -- Ideal RPM should be between 2200 and 2800 in normal operating limits
   type RevolutionsPerMinute is range 0..3000;
   
   -- define engine
   type Engine is tagged record
      status : EngineStatus;
      rpm : RevolutionsPerMinute;
   end record;
   
   -- Create airplane engines (2 of them)
   type Engines_Idx is range 0..1;
   type Engines is array (Engines_Idx) of Engine;
   
   -- used in other files to create an instance of Engines
   function GetEngines return Engines;

   -- turn engines on and off
   procedure TurnOnEngines(e : in out Engines) with
     Pre => EnginesOff(e),
     Post => EnginesOn(e) and (for all Z in e'Range => e(z).rpm <= 2800);
   
   procedure TurnOffEngines(e : in out Engines) with
     Pre => EnginesOn(e),
     Post => EnginesOff(e) and (for all Z in e'Range => e(z).rpm = 0);
   
   function EnginesOn(e : in Engines) return Boolean is
     (for all Z in e'Range => e(Z).status = On);
   
   function EnginesOff(e : in Engines) return Boolean is
     (for all Z in e'Range => e(Z).status = Off);
   
   procedure Accelerate(e : in out Engines) with
     Post => (for all Z in e'Range => e(Z).rpm <= RevolutionsPerMinute'Last);
   
   procedure Decelerate(e : in out Engines) with
     Post => (for all Z in e'Range => e(Z).rpm >= RevolutionsPerMinute'First);
   
end plane_engines;

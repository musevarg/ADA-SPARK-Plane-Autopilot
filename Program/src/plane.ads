with plane_doors; use plane_doors;
with plane_engines; use plane_engines;
with warning_lights; use warning_lights;

package plane with SPARK_Mode is

   -- Altitude in feet
   -- landing gear should be lowered below 1000 feet,
   -- ideal cruise altitude is between 30.000 and 40.000 feet
   type Altitude is range 0..45000;
   
   -- Airspeed in MPH
   -- ideal airspeed should be between 500 and 600 mph
   -- landing and takeoff speed should be between 150 and 200 mph
   type Airspeed is range 0..1000;
   
   -- Fuel in gallons
   -- A 10 hours flight uses about 36.000 gallons
   -- below this limit, the plane should not be allowed to takeoff
   type Fuel is range 0..50000;
   
   -- 4 flying statuses, in order to know which procedure to run
   type FlyingStatus is (Ready_For_Takeoff, Takeoff, Flying, Landing, Landed, Towed);
   
   -- 2 landing gear statuses
   -- landing gear should lower below 1000 feet
   type LandingGearStatus is (Lowered, Retracted);
     
  
   -- Create an instance of a plane.
   -- This is assumed to only happen when the plane
   -- is landed, not moving and engines are off.
   type Plane is tagged record
      current_altitude : Altitude := 0;
      all_doors : Doors := GetDoors;
      current_status : FlyingStatus := Landed;
      current_fuel : Fuel := 30000;
      landing_gear : LandingGearStatus := Lowered;
      current_speed : Airspeed := 0;
      all_engines : Engines := GetEngines;
      all_warning_lights : WarningLights := GetWarningLights;
   end record;
   
   
   function Invariant(p : in Plane) return Boolean is
     (DoorsLocked(p.all_doors) and 
         (p.current_status = Takeoff or 
          p.current_status = Flying or 
          p.current_status = Landing or 
          p.current_status = Ready_For_Takeoff));
   
   
   procedure GetReadyForTakeOff(p : in out Plane) with
     Post => IsReadyForTakeOff(p);
   
   
   procedure FillTank(f : in out Fuel) with
     Pre => (f < 50000),
     Post => (f >= 36000);
   
   function EnoughFuel(f : in Fuel) return Boolean is
     (f >= 36000);
   
   
   function IsReadyForTakeOff(p : in Plane) return Boolean is
     (p.current_status = Ready_For_Takeoff and Invariant(p) and (EnoughFuel(p.current_fuel)));
  
     
   

   
   
   procedure TakeOff(p : in out Plane) with
     Pre'Class => IsReadyForTakeOff(p),
     Post => (p.current_status = Flying) and (p.current_speed > 0) and (p.current_altitude > 0);
   
   
   
   function CorrectAltitude (a : in Altitude) return Boolean is
     ((a >= 30000) and (a <= 40000));
   
   function CorrectSpeed(s : in Airspeed) return Boolean is
     ((s >= 500) and (s <= 600));
   
   
   procedure FlightMode(p : in out Plane; s : in out Airspeed; a : in out Altitude) with
     Pre'Class => Invariant(p) and (p.current_status = Flying),
     Post => (p.current_status = Flying) and (CorrectAltitude(a)) and (CorrectSpeed(s));
   
   
   
   procedure Landing(p : in out Plane) with
     Pre'Class => (p.current_status = Landing),
     Post => IsLanded(p);
   
   function IsLanded(p : in Plane) return Boolean is
      (p.current_altitude = 0 and p.current_speed = 0 and p.current_status = Landed);
   
   procedure Landed(p : in out Plane) with
     Pre'Class => IsLanded(p) and DoorsClosed(p.all_doors) and DoorsLocked(p.all_doors) and EnginesOn(p.all_engines),
     Post => EnginesOff(p.all_engines) and DoorsOpened(p.all_doors);
   
   procedure Towed(p : in out Plane) with
     Pre'Class => (p.current_status = Landed),
     Post => (p.current_status = Towed);
   
   procedure ChangeSpeed(p : in out Plane; target_speed : in Airspeed) with
     Post => p.current_speed = p.current_speed'Old + (target_speed - p.current_speed'Old);
   
   procedure ChangeAltitude(p : in out Plane; target_alt : in Altitude) with
     Post => p.current_altitude = p.current_altitude'Old + (target_alt - p.current_altitude'Old);
    
   procedure ToggleLandingGear(p : in out Plane) with
     Post => (if p.current_altitude <= 1000 then p.landing_gear = Lowered else p.landing_gear = Retracted);
   
   
   procedure WarningLights(p : in out Plane) with
     Pre'Class =>  (for some Z in p.all_warning_lights'Range => p.all_warning_lights(Z).status = Off),
     Post => (for some Z in p.all_warning_lights'Range => p.all_warning_lights(Z).status = Off) or
             (for some Z in p.all_warning_lights'Range => p.all_warning_lights(Z).status = On);
     
   
end plane;

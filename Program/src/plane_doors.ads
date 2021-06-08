package plane_doors with SPARK_Mode is

   -- Define door statuses
   type OpenStatus is (Open, Closed);
   type LockStatus is (Unlocked, Locked);
     
   -- Define door
   type Door is tagged record
      status : OpenStatus;
      lock : LockStatus;
   end record;
      
   -- Define airplane doors
   -- 3 doors: cockpit, frontdoor and backdoor
   type Doors_Idx is range 0..2;
   type Doors is array (Doors_Idx) of Door;
   
   
   
   -- 2 Procedures to close and open doors
   procedure CloseDoors(d : in out Doors) with
     Pre => (for some Z in d'Range => d(Z).status = Open),
     Post => (for all Z in d'Range => d(Z).status = Closed);
   
   procedure OpenDoors(d : in out Doors) with
     Pre => (for some Z in d'Range => d(Z).status = Closed) and DoorsUnlocked(d),
     Post => (for all Z in d'Range => d(Z).status = Open);
   
   -- Function to check whether all doors are closed
   function DoorsClosed(d : in Doors) return Boolean is
     (for all Z in d'Range => d(Z).status = Closed);
   
   function DoorsOpened(d : in Doors) return Boolean is
      (for all Z in d'Range => d(Z).status = Open);
      
      
   
   -- 2 Procedures to lock and unlock doors
   procedure LockDoors(d : in out Doors) with
     Pre => (for some Z in d'Range => d(Z).lock = Unlocked) and DoorsClosed(d),
     Post => (for all Z in d'Range => d(Z).lock = Locked);
   
   procedure UnlockDoors(d : in out Doors) with
     Pre => (for some Z in d'Range => d(Z).lock = Locked) and DoorsClosed(d),
     Post => (for all Z in d'Range => d(Z).lock = Unlocked);
      
   -- 2 Functions to check whether all doors are locked or not
   function DoorsLocked(d : in Doors) return Boolean is
     (for all Z in d'Range => d(Z).lock = Locked);
   
   function DoorsUnlocked(d : in Doors) return Boolean is
     (for all Z in d'Range => d(Z).lock = Unlocked);
   
   
   -- used in other files to create an instance of doors
   function GetDoors return Doors;

end plane_doors;

with Ada.Text_IO;

package body plane_doors with SPARK_Mode is
   
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
   
   -- Close All Doors
   procedure CloseDoors(d : in out Doors)
   is
      Pos : Doors_Idx := d'First;
   begin
      while Pos < d'Last loop
         d(Pos).status := Closed;
         Pos := Pos + 1;
         pragma Loop_Invariant
             (for all Z in 0..(Pos-1) => d(Z).status = Closed);
      end loop;
      d(d'Last).status := Closed;
      Put_Line("Doors are closed.");
   end CloseDoors;
   
   -- Open All Doors
   procedure OpenDoors(d : in out Doors)
   is
      Pos : Doors_Idx := d'First;
   begin
      while Pos < d'Last loop
         d(Pos).status := Open;
         Pos := Pos + 1;
         pragma Loop_Invariant
             (for all Z in 0..(Pos-1) => d(Z).status = Open);
      end loop;
      d(d'Last).status := Open;
      Put_Line("Doors are opened.");
   end OpenDoors;
   
   -- Lock All Doors
   procedure LockDoors(d : in out Doors) 
   is
      Pos : Doors_Idx := d'First;
   begin
      while Pos < d'Last loop
         d(Pos).lock := Locked;
         Pos := Pos + 1;
         pragma Loop_Invariant
             (for all Z in 0..(Pos-1) => d(Z).lock = Locked);
      end loop;
      d(d'Last).lock := Locked;
      Put_Line("Doors are locked.");
   end LockDoors;
   
   -- Unlock All Doors
   procedure UnlockDoors(d : in out Doors) 
   is
      Pos : Doors_Idx := d'First;
   begin
      while Pos < d'Last loop
         d(Pos).lock := Unlocked;
         Pos := Pos + 1;
         pragma Loop_Invariant
             (for all Z in 0..(Pos-1) => d(Z).lock = Unlocked);
      end loop;
      d(d'Last).lock := Unlocked;
      Put_Line("Doors are unlocked.");
   end UnlockDoors;
   
   -- Create instance of doors
   function GetDoors return Doors is      
      doors_statuses : Doors :=
        (0 => (Closed, Locked),
         1 => (Closed, Locked),
         2 => (Closed, Locked));
   begin
      if DoorsLocked(doors_statuses) then
         UnlockDoors(doors_statuses);
      end if;
      if DoorsClosed(doors_statuses) then
         OpenDoors(doors_statuses);
      end if;
      return doors_statuses;
   end GetDoors;

end plane_doors;










































































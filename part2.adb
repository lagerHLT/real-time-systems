-- File: part2.adb

with Text_Io; use Text_Io;
with Ada.Calendar; use Ada.Calendar;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

-- main
procedure part2 is
	--variables
	tick : Duration := 1.0;
	startTime : Time := Clock;
	nextTime : Time := startTime;
	loopCount : Integer := 0;
	g : Generator;

	--task WatchDog
	task type WatchDog is
		entry Start;
		entry Stop;
	end Watchdog;

	task body WatchDog is
	begin
		select
			accept Start do
				select
					accept Stop;
				or
					delay 2.5;
					Put_Line("F3 execution took to long<-------------------------------------------------------------");
				end select;	
			end Start;
		or
			accept Stop;
		end select;
	end WatchDog;

	-- procedure F2
	procedure F2(startTime : in Time) is
	begin
		Put_Line("F2 executing, time is now: " & Duration'Image(Clock - startTime));
	end F2;

	-- procedure F1
	procedure F1(startTime : in Time) is
	begin
		Put_Line("F1 executing, time is now: " & Duration'Image(Clock - startTime));

		--start F2
		F2(startTime);
	end F1;

	-- procedure F3
	procedure F3(startTime : in Time; g : in Generator) is
		execTime : Float := Random(g);
		timer : WatchDog;
	begin
		--start WatchDog
		timer.Start;
		Put_Line("F3 executing, time is now: " & Duration'Image(Clock - startTime));
	
		--add a random time delay to F3
		--delay Duration(execTime);
		
		--end WatchDog
		timer.Stop;
	end F3;

begin
	--reset generator
	Reset(g);
	
	loop 
		Put_Line("----------------Tick " & Integer'Image(loopCount + 1) & "----------------");

		--wait until next tick
		delay until nextTime;
		F1(startTime);

		--execute F3 every other tick
		if (loopCount mod 2 = 0) then
			delay until nextTime + 0.5;
			F3(startTime, g);
		end if;

		--increment variables
		nextTime := nextTime + tick;
		loopCount := loopCount + 1;

		--end of tick
		new_line(1);
	end loop;
end part2;


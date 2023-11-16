% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 3.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      SECTION MAIN_1      %
%       MAIN SETUP         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");


%% Load the Linear UR5 model, Our Robot model, Environment and Models
%Initialize Our Main Robot- Linear UR5
clear
clc

UR5=OurLinearUR5;
DEN=OurDensoVS068;
q1=[-0.4 0 0 0 0 0 0];

workspace=[-2 5.25 -2 5 -0.5 3];
UR5.model.plot3d(q1,'nowrist','workspace',workspace,'notiles','noarrow','scale',0.25,'view','x','fps',60,'alpha',0);
app=teachGui;
app.UR5=UR5;
app.DEN=DEN;


hold on
% To prevent lagging with a functioning gripper. Have a static model
% attached onto the end effector and toggle on and off.
%  On: When the uses of the gripper is not needed. 
%  off: When a gripper (Serial-link) needs to be spawned in

DEN.model.base=eye(4)*transl(-0.5,-0.9,0)*trotz(-3*pi/2);
DEN.model.plot3d([0 0 0 0 0 0],'nowrist','workspace',workspace,'notiles','noarrow','scale',0.25,'view','x','fps',60,'alpha',0);
pause(0.1);



 dengripobj=Env('Environment\Mdl\DensoVS068\2F-140 Open Gripper.ply','Den Gripper',[0 0 0],1); %Spawn static open model to finish drag
 dengripobj.plot(DEN.model.fkine(DEN.model.getpos()).T*trotz(pi/2)); 

 pause(0.5);






% Initialize Main Environmment - Kitchen and Restaurant
Restobj(1)= Env("Environment\Env\env new.ply","table",[0 0 0],0);
Restobj(1).plot(trotx(pi/2)*troty(3*pi/2)*transl(-0.25,-0.05,0));


% Initialize Models for Restaurant

Restobj(2)= Env("Environment\Mdl\Restaurant\tray.ply","tray1",[0 0 0],1);
Restobj(2).plot(transl(0.26,0.75,0.2)*trotx(pi/2)*troty(pi/2));

Restobj(3)= Env("Environment\Mdl\Restaurant\tray.ply","tray2",[0 0 0],1);
Restobj(3).plot(transl(0.26,0.0,0.2)*trotx(pi/2)*troty(pi/2));

Restobj(4)= Env("Environment\Mdl\Restaurant\tray.ply","tray3",[0 0 0],1);
Restobj(4).plot(transl(0.26,0.-0.75,0.2)*trotx(pi/2)*troty(-pi/2));

Restobj(9)= Env("Environment\Mdl\Restaurant\sodamachine.ply","sodamachine",[0 0 0],1);
Restobj(9).plot(transl(-1.4,-1,0.2)*trotx(3*pi/2)*trotz(-pi));

axis equal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      SECTION MAIN_2      %
%     Initiate Customers   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Initiate the Director Class and Start Doing Orders
clc
app.x=input("How Many Customers do you want to Serve? (MAX=10) \nYour Input: ");

if app.x> 10
    error("Please serve less than 10 customers, as 10 is the MAX! ");
else
    pos=2;
    for i=1:app.x                                                           % Main For loop
        Customer(i)= Director();                                            % Randomised and spawn customers based on users amount

        xpos(i)=pos;
        CMod(i)= Env(Customer(i).Model + Customer(i).Variable + ".ply","Customer"+ i,[0 0 0],0);
        CMod(i).plot(transl(pos,4.5,-0.5));
        pos=pos+0.25;


        pause(0.1);
    end

    idx=1;  
    for i=1:size(Customer,2)

        Customer(i).tray=idx;
        idx=idx+1;

        if idx==4
            idx=1;
        end

    end


end




set=0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      SECTION MAIN_3                                      
%         MAIN LOOP                                        
%                                                          
%  The following occus per every reiteration of the loop   
%                                                          
%  STEP 1-                                                 
%  Delete customer model and spawn food items on their                                        
%  respective positons   [Line 184 - 200]                                                       
%  
%
%  STEP 2-
%  Update the customer model to 'waiting' status and 
%  spawn them by the window of the robotcell but 
%  not in close proximity with arms folded to indicate 
%  that he or she is waiting.   [Line 203 - 227]
%
%
%  STEP 3-
%  Extract UR5 position arrays of specific joint 
%  angles for movement. As well as a vector of model
%  references to indicate which model should be dragged
%  and traypos+=1 to distribute customer order by the robotcell 
%  window                       [Line 229]
%
%  STEP 4-
%  Produce a random generated integer where range is speicfied 
%  by the user. and spawn an incident like a fire occuring in the  
%  kitchen if the IF condition matches with the RNG.        [Line 231 - 240]
%                       
%
%  STEP 5-
%  Process the robotic movement, models being dragged with the robot
%  Initiating a safety incident from RNG and plotting/ updating food
%  models/ handles on the environment through the RobDo() function
%                               [Line 242 - 244]
%      
%
%  IF FOR EVERY THIRD CUSTOMER HAS BEEN SERVED PROCEED TO STEP 6 OTHERWISE 
%  RESTART LOOP 
%
%  STEP 6-
%  Despawn all of the customer models waiting and update their status 
%  to collecting their orders. Then proceeed to spawn them by the window
%  of the robotcell to collect their food that has been placed by the UR5
%  then proceed to despawn.         [Line 248 - 265]
%
% STEP 7-
% Despawn the trays of food and the customers and spawn them sitting with
% their food on a table             [Line 270 - 289]
%
%
% RESTART LOOP till finish
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for i=1:(app.x)

    delete(CMod(i).handle);

            % Respawn Large Burger
            Restobj(5)= Env("Environment\Mdl\Restaurant\hamburgerLRG.ply","Large Burger",[0 0 0],1);
            Restobj(5).plot(transl(-0.7,0.75,0.2));

            % Respawn Burger
            Restobj(6)= Env("Environment\Mdl\Restaurant\hamburger.ply","Burger",[0 0 0],1);
            Restobj(6).plot(transl(-0.45,0.75,0.2));

            % Respawn Fries
            Restobj(7)= Env("Environment\Mdl\Restaurant\fries.ply","Fries",[0 0 0],1);
            Restobj(7).plot(transl(-0.25,0.75,0.2));

            % Respawn Soda
            Restobj(8)= Env("Environment\Mdl\Restaurant\sodacup.ply","Soda",[0 0 0],1);
            Restobj(8).plot(transl(-0.8991, -0.7534, 0.2)*trotx(pi/2));


    Customer(i).Stat=1;
    switch Customer(i).update()



        case 0              % Waiting to Order or Picking up Food
            modarr=["Environment\Mdl\People\Male_Standing_";
                "Environment\Mdl\People\Female_Standing_"];
            Customer(i).Model=modarr(Customer(i).Gend,1);

        case 1              % Waiting for Food
            modarr=["Environment\Mdl\People\Male_Hips_";
                "Environment\Mdl\People\Female_Hips_"];
            Customer(i).Model=modarr(Customer(i).Gend,1);

            % Sitting down to Eat Food
           
    end


    CMod(i)= Env(Customer(i).Model + Customer(i).Variable +".ply","Customer"+ i,[0 0 0],0);
    xwait = round((2.0 + rand*(3.0-2.0))*10)/10;
    ywait = round((rand*(2-0)*10))/10;
    rang = [-45 -30 -15 0 0 15 30 45];
    CMod(i).plot(transl(xwait,ywait,-0.5)*trotz(deg2rad(rang(1,randi([1 8],1,1)))));

    [instructions,mod_reference,traypos]= Customer(i).Get(Customer(i).tray);                               

    incident_factor= 15; %     -% Percentage of an incident occuring for every order fulfilled3

    wrath= randi([1 100],1,1);
    if wrath>= 1 && wrath <=incident_factor
        incident= randi([1 5],1,1);
        incident=2;
    else
        incident=0;

    end
    
    gripobj=Env('Environment\Mdl\LinearUR5\Robotiq2845Open.ply','Static Open Gripper',[0 0 0],1);      %Spawn static open model to finish drag
    gripobj.plot(transl(0,0,-0.5)); 
    food_h{i}=RobDo(UR5,DEN, Customer(i),app,gripobj,dengripobj,Restobj,instructions,mod_reference,traypos,incident); 
    

    %% Have 3 customers in order, pickup their order and sit down
    if rem(i,3)==0                                                                                      % Once all three orders are made. 3 Customers will take their orders at a time

        pos=0.9;
        for j=(i-2):i
            delete(CMod(j).handle);                                                                     % Delete customers in waiting position
            Customer(j).Stat=0;

            modarr=["Environment\Mdl\People\Male_Standing_";
                "Environment\Mdl\People\Female_Standing_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);                                               % Change the model to stand, to pickup food

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);     %Create a temp model through the Env clas
            CMod(j).plot(transl(0.9,pos,-0.5));                                                         % Place them into getting orders
            pos=pos-0.9;
            % Delete food models
        end

        pause(3.0);                                                                                     % Delay the whole thing, to make it seem like theyre getting the food




        for j=(i-2):i
            delete(food_h{1,j}(1,:).handle)                                                            % Delete Customers that got their food
            delete(CMod(j).handle);
            Customer(j).Stat=2;                                                                        % Update Model that they got their food

            modarr=["Environment\Mdl\People\Male_Sit_";
                "Environment\Mdl\People\Female_Sit_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);

            xsit = round((3.0 + rand*(5.0-3.0))*10)/10;
            ysit = round((rand*(3.0-0)*10))/10;
            rangsit = [-180 -90 0 90 180];
            CMod(j).plot(transl(xsit,ysit,-0.5)*trotz(deg2rad(rangsit(1,randi([1 5],1,1)))));
           
        end   
         set=set+1;                                                                          
         trayidx=1;                                                                                   % Reset values for next iteration of the next 3 customers
    end

                                                                                      

end
  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      SECTION MAIN_4      
%        
%   If you finish the program with # of customers that
%   that are not divisible by 3 such as customers that are remainder 
%   from a 3 division. Or less than 3 customers. Proceed to sit everyone
%   down when everyone has their orders. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        
        pos=0.9;
        for j=(3*set)+1:app.x                                                                            % Consider odd amount of customers or finish everything
            delete(CMod(j).handle);                                                                      % Delete customers in waiting position
            Customer(j).Stat=0;

            modarr=["Environment\Mdl\People\Male_Standing_";
                "Environment\Mdl\People\Female_Standing_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);                                               % Change the model to stand, to pickup food

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);     %Create a temp model through the Env clas
            CMod(j).plot(transl(0.9,pos,-0.5));                                                         % Place them into getting orders
            pos=pos-0.9;
            % Delete food models
        end

        pause(3.0);                                                                                     % Delay the whole thing, to make it seem like theyre getting the food

        for j=(3*set)+1:app.x

            delete(food_h{1,j}(1,:).handle)                                                            % Delete Customers that got their food
            delete(CMod(j).handle);
            Customer(j).Stat=2;                                                                        % Update Model that they got their food

            modarr=["Environment\Mdl\People\Male_Sit_";
                "Environment\Mdl\People\Female_Sit_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);

            xsit = round((3.0 + rand*(5.0-3.0))*10)/10;
            ysit = round((rand*(3.0-0)*10))/10;
            rangsit = [-180 -90 0 90 180];
            CMod(j).plot(transl(xsit,ysit,-0.5)*trotz(deg2rad(rangsit(1,randi([1 5],1,1)))));

        end



        

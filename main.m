% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");


%% Load the Linear UR5 model, Our Robot model, Environment and Models
%Initialize Our Main Robot- Linear UR5


UR5=OurLinearUR5;
q1=[-0.3 0 0 0 0 0 0];
workspace=[-2 5.25 -2 5 -0.5 3];
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
UR5.model.delay=0;

pause(0.1);

UR5=OurLinearUR5;
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);

pause(0.5);

hold on
% Initialize Main Environmment - Kitchen and Restaurant

Restaurant_Models(1)= Env("Environment\Env\Environment_v1.ply","table",[0 0 0],0);
Restaurant_Models(1).plot(trotx(pi/2)*troty(3*pi/2)*transl(-0.25,-0.05,0));


% Initialize Models for Restaurant

Restaurant_Models(2)= Env("Environment\Mdl\Restaurant\hamburgerLRG.ply","large_burger",[0 0 0],1); 
Restaurant_Models(2).plot(transl(-0.7,0.75,0.2));

Restaurant_Models(3)= Env("Environment\Mdl\Restaurant\hamburger.ply","Burger",[0 0 0],1);
Restaurant_Models(3).plot(transl(-0.45,0.75,0.2));

Restaurant_Models(4)= Env("Environment\Mdl\Restaurant\fries.ply","fries",[0 0 0],1);
Restaurant_Models(4).plot(transl(-0.25,0.75,0.2));

Restaurant_Models(5)= Env("Environment\Mdl\Restaurant\sodacup.ply","soda",[0 0 0],1);
Restaurant_Models(5).plot(transl(0,-0.75,0.2)*trotx(pi/2));

Restaurant_Models(6)= Env("Environment\Mdl\Restaurant\tray.ply","tray1",[0 0 0],1);
Restaurant_Models(6).plot(transl(0.26,0.75,0.2)*trotx(pi/2)*troty(pi/2));

Restaurant_Models(7)= Env("Environment\Mdl\Restaurant\tray.ply","tray2",[0 0 0],1);
Restaurant_Models(7).plot(transl(0.26,0.0,0.2)*trotx(pi/2)*troty(pi/2));


Restaurant_Models(8)= Env("Environment\Mdl\Restaurant\tray.ply","tray3",[0 0 0],1);
Restaurant_Models(8).plot(transl(0.26,0.-0.75,0.2)*trotx(pi/2)*troty(pi/2));

axis equal


%% Initiate the Director Class and Start Doing Orders
clc
x=input("How Many Customers do you want to Serve? (MAX=10) \nYour Input: ");
if x> 100 error("Please serve less than 20 customers, as 20 is the MAX! ");
else
    pos=2;
    for i=1:x
        Customer(i)= Director();        % Randomised and spawn customers based on users amount

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




for i=1:(x)

    delete(CMod(i).handle);
  

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

        case 2              % Sitting down to Eat Food
            modarr=["Environment\Mdl\People\Male_Sit_";
                "Environment\Mdl\People\Female_Sit_"];
            Customer(i).Model=modarr(Customer(i).Gend,1);
    end


    CMod(i)= Env(Customer(i).Model + Customer(i).Variable +".ply","Customer"+ i,[0 0 0],0);
    xwait = round((2.0 + rand*(3.0-2.0))*10)/10;
    ywait = round((rand*(2-0)*10))/10;
    rang = [-45 -30 -15 0 0 15 30 45];
    CMod(i).plot(transl(xwait,ywait,-0.5)*trotz(deg2rad(rang(1,randi([1 8],1,1)))));

    [instructions,mod_reference]= Customer(i).Get(Customer(i).tray);

    incident_factor= 35; %     -% Percentage of an incident occuring for every order fulfilled

    wrath= randi([1 100],1,1);
    if wrath>= 1 && wrath <=incident_factor
        incident= randi([1 5],1,1);

    else
        incident=0;

    end

    RobDo(UR5, Customer(i),Restaurant_Models,instructions,mod_reference,incident);







end

% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 2.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");


%% Load the Linear UR5 model, Our Robot model, Environment and Models
%Initialize Our Main Robot- Linear UR5
clear
clc

UR5=OurLinearUR5;
q1=[-0.01 0 0 0 0 0 0];
workspace=[-2 5.25 -2 5 -0.5 3];
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
UR5.model.delay=0;

pause(0.1);

UR5=OurLinearUR5;
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);

pause(0.5);


pause(0.5);

hold on
% Initialize Main Environmment - Kitchen and Restaurant
Restobj(1)= Env("Environment\Env\Environment_v1.ply","table",[0 0 0],0);
Restobj(1).plot(trotx(pi/2)*troty(3*pi/2)*transl(-0.25,-0.05,0));


% Initialize Models for Restaurant

Restobj(2)= Env("Environment\Mdl\Restaurant\tray.ply","tray1",[0 0 0],1);
Restobj(2).plot(transl(0.26,0.75,0.2)*trotx(pi/2)*troty(pi/2));

Restobj(3)= Env("Environment\Mdl\Restaurant\tray.ply","tray2",[0 0 0],1);
Restobj(3).plot(transl(0.26,0.0,0.2)*trotx(pi/2)*troty(pi/2));

Restobj(4)= Env("Environment\Mdl\Restaurant\tray.ply","tray3",[0 0 0],1);
Restobj(4).plot(transl(0.26,0.-0.75,0.2)*trotx(pi/2)*troty(pi/2));

axis equal


%% Initiate the Director Class and Start Doing Orders
clc
x=input("How Many Customers do you want to Serve? (MAX=10) \nYour Input: ");
if x> 100 error("Please serve less than 20 customers, as 20 is the MAX! ");
else
    pos=2;
    for i=1:x                                                               % Main For loop
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


for i=1:(x)

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
            Restobj(8).plot(transl(0,-0.75,0.2)*trotx(pi/2));


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

    incident_factor= 15; %     -% Percentage of an incident occuring for every order fulfilled

    wrath= randi([1 100],1,1);
    if wrath>= 1 && wrath <=incident_factor
        incident= randi([1 5],1,1);

    else
        incident=0;

    end


    food_h{i}=RobDo(UR5, Customer(i),Restobj,instructions,mod_reference,traypos,incident); 
    

    j=i;

    %% Have 3 customers in order, pickup their order and sit down
    if rem(i,3)==0                                                                              % Once all three orders are made. 3 Customers will take their orders at a time

        pos=0.9;
        for j=(i-2):i
            delete(CMod(j).handle);                                                                     % Delete customers in waiting position
            Customer(j).Stat=0;

            modarr=["Environment\Mdl\People\Male_Standing_";
                "Environment\Mdl\People\Female_Standing_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);                                       % Change the model to stand, to pickup food

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);     %Create a temp model through the Env clas
            CMod(j).plot(transl(0.9,pos,-0.5));                                                         % Place them into getting orders
            pos=pos-0.9;
            % Delete food models
        end

        pause(3.0);                                                                                % Delay the whole thing, to make it seem like theyre getting the food

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
  
        
        
        pos=0.9;
        for j=(3*set)+1:x                                                                      % Consider odd amount of customers or finish everything
            delete(CMod(j).handle);                                                             % Delete customers in waiting position
            Customer(j).Stat=0;

            modarr=["Environment\Mdl\People\Male_Standing_";
                "Environment\Mdl\People\Female_Standing_"];
            Customer(j).Model=modarr(Customer(j).Gend,1);                                       % Change the model to stand, to pickup food

            CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ j,[0 0 0],0);     %Create a temp model through the Env clas
            CMod(j).plot(transl(0.9,pos,-0.5));                                                         % Place them into getting orders
            pos=pos-0.9;
            % Delete food models
        end

        pause(3.0);                                                                                % Delay the whole thing, to make it seem like theyre getting the food

        for j=(3*set)+1:x

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



        





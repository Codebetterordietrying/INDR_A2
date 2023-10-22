% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");


%% Load the Linear UR5 model, Our Robot model, Environment and Models
%Initialize Our Main Robot- Linear UR5

UR5=OurLinearUR5;
q1=[-0.01 0 0 0 0 0 0];
workspace=[-2 5.25 -2 5 -0.5 3];
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
UR5.model.delay=0;

pause(0.5);

UR5=OurLinearUR5;
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);

pause(0.5);

hold on
% Initialize Main Environmment - Kitchen and Restaurant

  table= Env("Environment\Env\Environment_v1.ply","table",[0 0 0],0);
  table.plot(trotx(pi/2)*troty(3*pi/2)*transl(-0.25,-0.05,0));
   
% Initialize Models for Restaurant 

  lrgburg= Env("Environment\Mdl\Restaurant\hamburgerLRG.ply","large_burger",[0 0 0],1);
  [lb_h,lb_v] =lrgburg.plot(transl(-0.7,0.75,0.2));

  burg= Env("Environment\Mdl\Restaurant\hamburger.ply","Burger",[0 0 0],1);
  burg.plot(transl(-0.45,0.75,0.2));

  fries= Env("Environment\Mdl\Restaurant\fries.ply","fries",[0 0 0],1);
  fries.plot(transl(-0.25,0.75,0.2));

  fries= Env("Environment\Mdl\Restaurant\fries.ply","fries",[0 0 0],1);
  fries.plot(transl(-0.25,0.75,0.2));

  axis equal


%% Initiate the Director Class and Start Doing Orders
clc
x=input("How Many Customers do you want to Serve? (MAX=10) \nYour Input: ");
if x> 100 error("Please serve less than 10 customers, as 10 is the MAX! "); 
else
pos=2;
for i=1:x
Customer(i)= Director();
xpos(i)=pos;

CMod(i)=    Env(Customer(i).Model + Customer(i).Variable + ".ply","Customer"+ i,[0 0 0],0);
[CModH(i)]=CMod(i).plot(transl(pos,4.5,-0.5));
pos=pos+0.25;


pause(0.1);
end
end




for i=1:(x)

delete(CModH(i));
Customer(i).Stat=1;
CMod(i)= Env(Customer(i).Model + Customer(i).Variable +".ply","Customer"+ i,[0 0 0],0);
xwait = round((2.0 + rand*(3.0-2.0))*10)/10;
ywait = round((rand*(2-0)*10))/10;
[CModH(i)]=CMod(i).plot(transl(xwait,ywait,-0.5));

pause(1.5);


for j= i+1:x

delete(CModH(j));
CMod(j)= Env(Customer(j).Model + Customer(j).Variable +".ply","Customer"+ i,[0 0 0],0);
[CModH(j)]=CMod(j).plot(transl(xpos(j)-0.25,4.5,-0.5));
pause(0.1);

end

end





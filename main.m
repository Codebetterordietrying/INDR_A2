% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");

%% Load the Linear UR5 model, Our Robot model, Environment and Models

   h = PlaceObject("Environment\Env\table_test_v2.ply",[-0.25,-0.015,0]);
            verts = [get(h,'Vertices'), ones(size(get(h,'Vertices'),1),1)] * troty(pi/2)*trotx(-pi/2);
            set(h,'Vertices',verts(:,1:3))

%Origin pose and joint angles

workspace=[-2 2 -2 3 -0.5 3];
name='linearur5';
op='no';

UR5=OurLinearUR5;
q1=[-0.01 0 0 0 0 0 0];
UR5.model.plot3d(q1,'nowrist','noarrow','notiles','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
axis equal

%% Move the Robot through teach() and getpos() REV 1.0      (Subjected to change)


qb1=[-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955         0]; % Pose of the waypoint
qb2=[-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Pose of hovering Reg Burger


qmatrix1=jtraj(q1,qb1,50);
qmatrix2=jtraj(qb1,qb2,50);

while 1
for i=1:50
    
   UR5.model.animate(qmatrix1(i,:));
   drawnow();
   axis equal

end

for i=1:50
    
   UR5.model.animate(qmatrix2(i,:));
   drawnow();
   axis equal

end
end

% Notepad: 

% FOOD STATION
% Reg Burgers = [-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Lrg Burgers = [-0.4050    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Reg Chips   = [-0.2075    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Lrg Chips   = [-0.0265    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]



% WAYPOINTS
% Fstat Wayp  = [-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955         0]

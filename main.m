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

workspace=[-2 2 -2 2 -0.01 3];
name='linearur5';
op='no';

UR5=OurLinearUR5;
q1=[-0.01 0 0 0 0 0 0];
UR5.model.plot3d(q1,'nowrist','noarrow','notiles','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
axis equal




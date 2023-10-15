% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");

%% Load the Linear UR5 model, Our Robot model, Environment and Models

   h = PlaceObject('table_test.ply',[0,0,0]);
            verts = [get(h,'Vertices'), ones(size(get(h,'Vertices'),1),1)] * troty(pi/2)*trotx(-pi/2);
            set(h,'Vertices',verts(:,1:3))
axis equal

%Origin pose
og=eye(4);
UR5=LinearUR5(og);
UR5.model.teach(zeros(1,UR5.model.n))

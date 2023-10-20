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
workspace=[-2 2 -2 3 -0.5 3];
UR5.model.plot3d(q1,'notiles','nowrist','noarrow','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);
UR5.model.delay=0;

hold on
% Initialize Main Environmment - Kitchen and Restaurant

  table= Env("Environment\Env\table_test_v2.ply","table",[0 0 0],0);
  table.plot(trotx(pi/2)*troty(3*pi/2)*transl(-0.25,-0.05,0));
   
% Initialize Models for Restaurant 

  lrgburg= Env("Environment\Mdl\Restaurant\hamburgerLRG.ply","large_burger",[0 0 0],1);
  [lb_h,lb_v] =lrgburg.plot(transl(-0.7,0.75,0.2));

  burg= Env("Environment\Mdl\Restaurant\hamburger.ply","Burger",[0 0 0],1);
  burg.plot(transl(-0.45,0.75,0.2));

  fries= Env("Environment\Mdl\Restaurant\fries.ply","fries",[0 0 0],1);
  fries.plot(transl(0.3,0.95,-0.1));

  axis equal

%%

qb1=[-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955         0]; % Pose of the waypoint
qb2=[-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Pose of hovering Reg Burger
qb3=[-0.0100   -3.6880    1.1610   -0.1290    0.2732    1.6391         0]; % Pose to drop off on tray 1



% q matrices of paths

qmatrix1=jtraj(q1,qb1,50);
qmatrix2=jtraj(qb1,qb2,50);
qmatrix3=jtraj(qb2,qb1,50);
dropmatrix=jtraj(qb1,qb3,50);


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




for i=1:50
    
  UR5.model.animate(qmatrix3(i,:));
  tr=UR5.model.fkine(qmatrix3(i,:)).T;
  lrgburg.update(lb_h,lb_v,tr);
   pause(0.01);
     axis equal

end


for i=1:50
    
   UR5.model.animate(dropmatrix(i,:));
   tr=UR5.model.fkine(dropmatrix(i,:)).T;
   lrgburg.update(lb_h,lb_v,tr);
    pause(0.01);
    axis equal

end



end




%for i = 1:50
  
%end

% Notepad: 

% FOOD STATION
% Reg Burgers = [-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Lrg Burgers = [-0.4050    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Reg Chips   = [-0.2075    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]
% Lrg Chips   = [-0.0265    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]



% WAYPOINTS
% Fstat Wayp  = [-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955         0]

% Dropoff
% Tray 1      = [-0.0100   -3.6880    1.1610   -0.1290    0.2732    1.6391         0]




%% test

UR51=OurLinearUR5;
q1=[-0.01 0 0 0 0 0 0];
workspace=[-2 2 -2 3 -0.5 3];
UR51.model.plot3d(q1,'nowrist','noarrow','notiles','workspace',workspace,'scale',0.25,'view','x','fps',60,'alpha',0);

hold on


h1 = PlaceObject("Environment\Mdl\Restaurant\hamburgerLRG.ply",[-0.2,1.4,-0.1]);
vertices = get(h1,'Vertices');

            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0.3,0.025,-0.05);
            set(h1,'Vertices',transformedVertices(:,1:3));

                     

qb1=[-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955         0]; % Pose of the waypoint
qb2=[-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Pose of hovering Reg Burger
qb3=[-0.0100   -3.6880    1.1610   -0.1290    0.2732    1.6391         0]; 

qmatrix1=       jtraj(q1,qb1,50);
qmatrix2=       jtraj(qb1,qb2,50);
qmatrix3=       jtraj(qb2,qb1,50);
dropmatrix=     jtraj(qb1,qb3,50);


axis equal
while 1

for i=1:50
    
    UR51.model.animate(qmatrix3(i,:));
    transform= UR51.model.fkine(qmatrix3(i,:));

    hom=[transform.n transform.o transform.a transform.t ; 0 0 0 1];

    transformedVertices = [vertices,ones(size(vertices,1),1)] * hom';
    set(h1,'Vertices',transformedVertices(:,1:3));

   drawnow();


end

end


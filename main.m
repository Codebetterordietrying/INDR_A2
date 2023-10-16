% LAB ASSESSMENT 2: CHEFMATE -MAIN PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Load the toolbox (If installed in different directory, load it outside of this script)
run("C:\Windows\System32\rvctools\startup_rvc.m");

%% Load the Linear UR5 model, Our Robot model, Environment and Models

   h = PlaceObject('table_test_v2.ply',[0,0,0]);
            verts = [get(h,'Vertices'), ones(size(get(h,'Vertices'),1),1)] * troty(pi/2)*trotx(-pi/2);
            set(h,'Vertices',verts(:,1:3))

%Origin pose and joint angles
og=eye(4)*transl(-0.01,-0.25,0.05);


UR5=;
q1=[0.01 0 0 0 0 0 0];

UR5.model.plot(q1);

axis equal

%%
q0= [0.01, 0, 0, 0, 0, 0, 0];

            link(1) =   Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            link(2) = Link([0      0.1599  0       -pi/2   0]);
            link(3) = Link([0      0.1357  0.425   -pi     0]);
            link(4) = Link([0      0.1197  0.39243 pi      0]);
            link(5) = Link([0      0.093   0       -pi/2   0]);
            link(6) = Link([0      0.093   0       -pi/2	0]);
            link(7) = Link([0      0       0       0       0]);
            
            % Incorporate joint limits
            link(1).qlim = [0.01 0.8];
            link(2).qlim = [-360 360]*pi/180;
            link(3).qlim = [-90 90]*pi/180;
            link(4).qlim = [-170 170]*pi/180;
            link(5).qlim = [-360 360]*pi/180;
            link(6).qlim = [-360 360]*pi/180;
            link(7).qlim = [-360 360]*pi/180;
        
            link(3).offset = -pi/2;
            link(5).offset = -pi/2;
            
            self = SerialLink(link,'name','test');
            self.teach(q0);

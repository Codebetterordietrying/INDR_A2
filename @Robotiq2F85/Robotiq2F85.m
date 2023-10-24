classdef Robotiq2F85 < RobotBaseClass

    properties(Access = public)              
        plyFileNameStem = 'Robotiq2F85';
    end
    
    methods
        
    function self = Robotiq2F85(baseTr)
			self.CreateModel();
            if nargin < 1			
				baseTr = eye(4);				
            end
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);
            
            self.PlotAndColourRobot();         
    end
%% Create the robot model
        function CreateModel(self)   
            % Create the UR3 model mounted on a linear rail
            link(1) = Link([0      0      0.05      0      0]);
            link(2) = Link([0      0      0.045     0      0]);
            link(3) = Link([0      0      0.045     0      0]);

            % Incorporate joint limits
            link(1).qlim = [-90 90]*pi/180;
            link(2).qlim = [-90 90]*pi/180;
            link(3).qlim = [-90 90]*pi/180;

            link(1).offset = -16.1975*pi/180;
            link(2).offset = 58*pi/180;
            link(3).offset = 48*pi/180;

            base = eye(4);
            
            self.model = SerialLink(link,'name',self.name,'base',base);
        end
    end
end
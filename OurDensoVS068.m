% LAB ASSESSMENT 2: CHEFMATE -Denso VS068 PROGRAM
% Main program that runs and coordinates all sub-programs for the task
% Author: Rohit Bhat
% Rev: 2.0


classdef OurDensoVS068 < RobotBaseClass
    properties(Access = public)  
        plyFileNameStem = 'Environment\Mdl\DensoVS068\DensoVS068';
    end
    methods (Access = public)
%% Constructor 
        function self = OurDensoVS068(baseTr)
			self.CreateModel();
            if nargin == 1			
				self.model.base = self.model.base.T * baseTr;
            end
            
            self.PlotAndColourRobot();         
        end

%% CreateModel
        function CreateModel(self)       
         
            link(1) = Link('alpha',pi/2,'a',0, 'd',0.37, 'offset',pi,'qlim',[deg2rad(-170), deg2rad(170)] );
            link(2) = Link('alpha',0,'a',0.35, 'd',0, 'offset',pi/2,'qlim',[deg2rad(-100), deg2rad(135)]);
            link(3) = Link('alpha',-pi/2,'a',0.01, 'd',0,'offset',0,'qlim',[deg2rad(-120), deg2rad(153)]);
            link(4) = Link('alpha',pi/2,'a',0, 'd',0.335, 'offset',0,'qlim',[deg2rad(-270), deg2rad(270)]);
            link(5) = Link('alpha',-pi/2,'a',0, 'd',0, 'offset',pi/2,'qlim',[deg2rad(-120), deg2rad(120)]);
            link(6) = Link('alpha',0,'a',0, 'd',0.08, 'offset',0,'qlim',[deg2rad(-360), deg2rad(360)]);

            self.model = SerialLink(link,'name',self.name); 
        end    
    end
end
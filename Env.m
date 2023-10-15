% LAB ASSESSMENT 2: ENV CLASS
% Load up the environment ply file and a series of model files
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Env Class
classdef Env
  
    
    properties
        Property1
    end
    
    methods
        function obj = Env(inputArg1,inputArg2)
            %ENV Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end


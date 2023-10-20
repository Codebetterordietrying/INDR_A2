% LAB ASSESSMENT 2: ENV CLASS
% Load up the environment ply file and a series of model files
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.0

%% Env Class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROPERTIES

% path          :   Pathfile of the model in the directory
% model         :   Name of the Model used
% init          :   Initial Coordinates of Cartersian 
% static        :   Static status , 0: Does not move 1: Will move

% METHODS

% plot()        :   Implement models onto 3D-graph. Must be called FIRST
%                   Input:  4x4 Homogeneous Matrix i.e: eye(4), transl()...
% 
% update()      :   Update the pose of the models in the 3D-graph.
%                   Static bool must be 1. If 0, an error occurs
%                   Input:  4x4 Homogeneous Matrix i.e.: eye(4), transl()..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Env < handle
  properties
        
         path       

         model       

        init=[]    
            
        static     
        
        
    end
    


    methods 
        function self = Env(path,model,init,static) % Constructor to initialize models and set in class
              %input: File path in string format, custom name, initial coordinates, bool for static

            % Copy the attributes of the model and set them to the class of its own

            self.path=path;

            self.model=model;

            if nargin==2

            self.init=[0 0 0];
            self.static=0;
            else
           
            
            self.init=init;
            self.static=static;  % 0= Not moving    1= Will move
            end        
        end



        function [handle,vertices] = plot(self,tr) %Function to plot the initialized models onto the graph 
           % IN YZX FORMAT   [   X=Y, Y=Z , Z=X ]
            % Input: 4x4 Homogenous Matrix

          
                    
           handle = PlaceObject(self.path,self.init);
           vertices = get(handle,'Vertices');
          
          if nargin==2 


           transformedVertices = [vertices,ones(size(vertices,1),1)] * tr';
           set(handle,'Vertices',transformedVertices(:,1:3));
          
          elseif nargin==1
           transformedVertices = [vertices,ones(size(vertices,1),1)] * eye(4);
           set(handle,'Vertices',transformedVertices(:,1:3));   
          end

        end

    



        function update(self,handles,vertices,tr) %Use this function to update transform of the model (When animating)
            % Input: modle_handle , modle_vertices matrix, 4x4 Homogenous Matrix
        
        if self.static==1
        transformedVertices1 = [vertices,ones(size(vertices,1),1)] * tr';
        set(handles,'Vertices',transformedVertices1(:,1:3));
                
        else
        
        error("Model is static, change static status if the model will move");
        end
        
    end
end
end

% LAB ASSESSMENT 2: DIRECTOR CLASS
% Instructs the robot and all processes to function for the scirpt.
% Author: Yves Gayagay
% Rev: 2.0

%% Director Class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROPERTIES

% Name                  :   Name of the Customer for ordering
% Order                 :   Order of the food in int
% Variable              :   Variable of the Model
% Model                 :   The filepath of the model
% Stat                  :   The current status of the model




% METHODS

% Director()             :  Constuctor Order of the person, if no input= randomized
%                           Input: ["Name",Order,Variable,Model]
%                                    Name= Name IN STRING
%                                    Order= Orders represents in 1<x<6
%                                    Variable= Number 0, 1 or 2 [Waiting To Order, Waiting for Food, Eating]
%                                    Model= filepath IN STRING
%
% Get()                 :   Order of the food that gives out instructions
%                           for robots
%                            Input: order number from class
%                       
%                       Order 1: 1x lrg Burg, 1x Fries,  1x Soda
%                       Order 2: 1x Burg    , 1x Fries,  1x Soda
%                       Order 3:            , 1x Fries , 1x Soda
%                       Order 4: 1x Burg    ,          , 1x Soda
%                       Order 5: 1x Lrg Burg   
%                       Order 6:            , 3x Fries
%
%
% 
%
%
% Update()              : Change the models of the customer based on
%                         updated status 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



classdef Director  
    properties
        Name
        Model
        Order
        Variable

        Stat
        Gend
        tray


    end
    
    methods
        function self = Director(input1)
            

            if nargin>10
            error("Please use a value of less than 10, which is the MAX");

            elseif nargin==0 
         
    Namearr=["Keila" "Jase" "Nelson" " Madeline" "Dayanara" "Colt" "Joseph";
               "Alea"  " Chelsea" "Sarah" "Rocky" "Bryon" "Ezra" "Nacho";
               "Gavin" "Yves" "Michele" "Rohit" "Anne" "Kyler" "Stuart";
                "Wendy" "Samira" "Alonso" "Layla" "Christian" "Zaira" "Ty"];
    
   rnamec = randi([1 7],1,1);
   rnamer = randi([1 4],1,1);
   self.Name=Namearr(rnamer,rnamec);                 % Random Name given

    self.Stat=0;  

                                      % If Customer is going to Order

     modarr=["Environment\Mdl\People\Male_Standing_";
            "Environment\Mdl\People\Female_Standing_"];
            

            
           

   modr=randi([1 2],1,1);                             % Random Model Gen
   self.Model=modarr(modr,1); 

   if self.Model== modarr(1,1)
   self.Gend=1;                                       % Assign male gender 

   elseif self.Model== modarr(2,1)                    % Assign Female Gender
   self.Gend=2; 
   end

 

    self.Order=randi([1 6],1,1);                      % Random Order Number
        
   self.Variable=randi([0 2],1,1);                    %  Random Variable 

   
       % Random Status
   
            else

   self.Name=input1(1,1);
   self.Order=input1(1,2);
   self.Variable=input1(1,3);
   self.Stat=0;

            end
 end
       
        








 function [instruct,ref,traypos]=Get(self,ttray)

% PRE INPUTTED JOINT ANGLES FOR THE END EFFECTOR USING IKINE AND TEACH FOR THE LINEAR UR5     

% ORGIN
       ORIGIN         = [-0.4        0        0         0         0         0             0];

% FOODSTATION   
       Lrg_Burger    = [-0.6746    0.1496   -0.7106    1.0832    0.0997   -1.3464         0]; % Model Reference: 1 
       Reg_Burger    = [-0.4269    0.1496   -0.7729    1.0832    0.2992   -1.3464         0]; % Model Reference: 2   
       Reg_Fries     = [-0.2138    0.1496   -0.6607    1.1303    0.2992   -1.3464         0]; % Model Reference: 3
       Soda          = [-0.2138   -2.7427   -0.8353    1.3893    2.0944   -1.5957   -0.0499]; % Model Reference: 4

% Tray Dropoffs
       Tray_1        = [-0.2138   -0.4987   -0.9350    0.8242    0.4488   -1.3464    1.1469];  
       Tray_2        = [-0.2138   -1.4461   -0.0249    2.0958    0.5984   -1.4960    0.1995];
       Tray_3        = [-0.2138   -2.4435   -0.9599    0.7300    0.0997   -1.5957   -0.3989];




        if ttray==1                                                                         % Models and robot's trajectory changes based on which tray is being packd
        switch self.Order               
            case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_1; Reg_Fries ; Tray_1; Soda; Tray_1 ];  % Make a column vector of joint angles, to be incremented through for jtraj
                ref =[0 1 0 3 0 4 0];                                                       % Using model reference above. Create a row vector of number signals to determine sequence of models to be picked up
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2];                       % Coordinates for the food models to go to, when placed on trays

            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_1; Reg_Fries; Tray_1; Soda; Tray_1  ];
                ref =[0 2 0 3 0 4 0];
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2]; 

            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_1; Soda; Tray_1; zeros(1,7); zeros(1,7) ];
                ref =[0 3 0 4 0 0 0];
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_1; Soda; Tray_1; zeros(1,7); zeros(1,7)];
                ref =[0 2 0 4 0 0 0];
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_1; zeros(1,7); zeros(1,7); zeros(1,7); zeros(1,7) ];
                ref =[0 1 0 0 0 0 0];
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_1; zeros(1,7); zeros(1,7); zeros(1,7); zeros(1,7)] ;
                ref =[0 3 0 0 0 0 0];
                traypos=[0.25 0.9 0.2 ; 0.25 0.8 0.2 ; 0.25 0.7 0.2];

         end
       
        

          elseif ttray==2
          switch self.Order               
               case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_2; Reg_Fries ; Tray_2; Soda; Tray_2 ];
                ref =[0 1 0 3 0 4 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];

            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_2; Reg_Fries; Tray_2; Soda; Tray_2  ];
                ref =[0 2 0 3 0 4 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];
                    
            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_2; Soda; Tray_2  ];
                ref =[0 3 0 4 0 4 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_2; Soda; Tray_2];
                ref =[0 2 0 4 0 0 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_2 ];
                ref =[0 1 0 0 0 0 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_2];
                ref =[0 3 0 0 0 0 0];
                traypos=[0.25 0.1 0.2 ; 0.25 0 0.2 ; 0.25 -0.1 0.2];


          end
          



     elseif ttray==3
          switch self.Order               
            case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_3; Reg_Fries ; Tray_3; Soda; Tray_3 ];
                ref =[0 1 0 3 0 4 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2];
            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_3; Reg_Fries; Tray_3; Soda; Tray_3  ];
                ref =[0 2 0 3 0 4 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2]; 

            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_3; Soda; Tray_3   ];
                ref =[0 3 0 4 0 4 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_3; Soda; Tray_3];
                ref =[0 2 0 4 0 0 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_3 ];
                ref =[0 1 0 0 0 0 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_3];
                ref =[0 3 0 0 0 0 0];
                traypos=[0.25 -0.7 0.2 ; 0.25 -0.8 0.2 ; 0.25 -0.9 0.2];

          end
       end

      end


      
      function stat=update(self)                                            % Change the status of models for diaagnostic purposes and updating models, for given state 
            if self.Stat==0
                stat=0;     
            elseif self.Stat==1
                stat=1;                        
            elseif self.Stat==2
                stat=2;
  
            end
            end

end

end


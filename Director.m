% LAB ASSESSMENT 2: ENV CLASS
% Instructs the robot and all processes to function for the scirpt.
% Author: Yves Gayagay, Michele Liang, Rohit Bhat
% Rev: 1.5

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
% Finish()              :   Destructor to delete the order once it is
%                           finished
%                           Input: No Input
%
%
% Event()               :  Random Event occurs in simulation to show of
%                          safety features
%                          Input: Randomized number

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
       
        








 function [instruct,ref]=Get(self,ttray)
% ORGIN
       ORIGIN         = [-0.4        0        0         0         0         0             0];

% FOODSTATION        
       Reg_Burger    = [-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Model Reference: 1
       Lrg_Burger    = [-0.4050    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Model Reference: 2
       Reg_Fries     = [-0.2075    3.0543    0.6912   -1.0978   -0.2409    1.5708         0]; % Model Reference: 3
       Soda          = [-0.1746    0.2618    0.7854   -0.9890   -0.2618    1.5708         0]; % Model Reference: 4

% Tray Dropoffs
       Tray_1        = [-0.0100    2.6180    0.9163   -0.7418   -0.2618    1.5708         0];  
       Tray_2        = [-0.0100    1.5708   -0.3927   -2.4726   -0.5236    1.5708         0];
       Tray_3        = [-0.0100    0.5236    0.0654   -1.9780   -0.5236    1.5708         0];




        if ttray==1
        switch self.Order               
            case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_1; Reg_Fries ; Tray_1; Soda; Tray_1 ];
                ref =[0 2 0 3 0 4 0];

            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_1; Reg_Fries; Tray_1; Soda; Tray_1  ];
                ref =[0 1 0 3 0 4 0];
                    
            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_1; Soda; Tray_1; zeros(1,7); zeros(1,7) ];
                ref =[0 3 0 3 0 0 0];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_1; Soda; Tray_1; zeros(1,7); zeros(1,7)];
                ref =[0 2 0 4 0 0 0];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_1; zeros(1,7); zeros(1,7); zeros(1,7); zeros(1,7) ];
                ref =[0 1 0 0 0 0 0];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_1; zeros(1,7); zeros(1,7); zeros(1,7); zeros(1,7)] ;
                ref =[0 3 0 0 0 0 0];

         end
       
        

          elseif ttray==2
          switch self.Order               
               case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_2; Reg_Fries ; Tray_2; Soda; Tray_2 ];
                ref =[0 2 0 3 0 4 0];

            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_2; Reg_Fries; Tray_2; Soda; Tray_2  ];
                ref =[0 1 0 3 0 4 0];
                    
            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_2; Soda; Tray_2   ];
                ref =[0 3 0 3 0 4 0];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_2; Soda; Tray_2];
                ref =[0 2 0 4 0 0 0];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_2 ];
                ref =[0 1 0 0 0 0 0];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_2];
                ref =[0 3 0 0 0 0 0];

          end
          



     elseif ttray==3
          switch self.Order               
            case 1
                instruct=[ORIGIN ; Lrg_Burger; Tray_3; Reg_Fries ; Tray_3; Soda; Tray_3 ];
                ref =[0 2 0 3 0 4 0];

            case 2
                instruct=[ORIGIN; Reg_Burger; Tray_3; Reg_Fries; Tray_3; Soda; Tray_3  ];
                ref =[0 1 0 3 0 4 0];
                    
            case 3
                instruct=[ORIGIN; Reg_Fries; Tray_3; Soda; Tray_3   ];
                ref =[0 3 0 3 0 4 0];

            case 4
                instruct=[ORIGIN; Reg_Burger; Tray_3; Soda; Tray_3];
                ref =[0 2 0 4 0 0 0];
                
            case 5
                instruct=[ORIGIN; Lrg_Burger; Tray_3 ];
                ref =[0 1 0 0 0 0 0];


            case 6
                instruct=[ORIGIN; Reg_Fries; Tray_3];
                ref =[0 3 0 0 0 0 0];

          end
       end

      end


      
      function stat=update(self)
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


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
       
        








      function instruct=Get(self,ttray)
% FOODSTATION        
       Reg_Burger = [-0.6683    3.0543    0.6912   -1.0978   -0.2409    1.5708         0];
       Lrg_Burger = [-0.4050    3.0543    0.6912   -1.0978   -0.2409    1.5708         0];
       Reg_Fries   = [-0.2075    3.0543    0.6912   -1.0978   -0.2409    1.5708         0];
      


% ORGIN
       ORIGIN         =[-0.01        0        0         0         0         0              0];

% WAYPOINTS
       Fstat_Wayp    =[-0.3329    3.0917    0.9225    0.3532    0.4488    1.6955          0];

% Tray Dropoffs
       Tray_1        = [-0.0100   -3.6880    1.1610   -0.1290    0.2732    1.6391         0];    


        if ttray==1
        switch self.Order               
            case 1
                instruct=[ORIGIN ;Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_1 ];
                
            case 2
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_1; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_1  ];

            case 3
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_1  ];
            case 4
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_1];

            case 5
                instruct=[ORIGIN; Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_1];

            case 6
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_1];
         end
       
        

          elseif ttray==2
          switch self.Order               
            case 1
                instruct=[ORIGIN ;Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_2 ];
                
            case 2
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_2; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_2  ];

            case 3
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_2  ];

            case 4
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_2];

            case 5
                instruct=[ORIGIN; Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_2];

            case 6
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_2];
          end
          



     elseif ttray==3
          switch self.Order               
            case 1
                instruct=[ORIGIN ;Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_3 ];
                
            case 2
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_3; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_3  ];

            case 3
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_3 ];
            case 4
                instruct=[ORIGIN; Fstat_Wayp; Reg_Burger; Fstat_Wayp; Tray_3];

            case 5
                instruct=[ORIGIN; Fstat_Wayp; Lrg_Burger; Fstat_Wayp; Tray_3];

            case 6
                instruct=[ORIGIN; Fstat_Wayp; Reg_Fries; Fstat_Wayp; Tray_3];
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


function  Restobj= RobDo(robobj,custobj,gripobj,models,instruct,ref,traypos, incident)

% SUB-FUNCTION TO OPEN AND CLOSE ROBOTIC GRIPPER
function grip(int,tr) % Spawn and delete gripper moddel. For picking and dropping animations. To conserve on performance
                      % Tr= transform of the end effecotr before it starts
                      % to pick up food



stepss=10;          % How many frames you want per animation of opening or closing

startq= [0.3916   -0.9896   -0.6696];
pickq=  [0.5854    0.2232   -0.8128];

closematrix=jtraj(startq,pickq,stepss)  ;
openmatrix=jtraj(pickq,startq,stepss);


if int==1          % Spawn and close gripper to pick things up
    
     delete(gripobj.handle);
     delete(gripobj);                        % Delete Open gripper static model to spawn functioning gripper
     clear gripobj

    disp('***Picking up item***');


    funcgrip(1)=Robotiq2F85(tr.T*trotz(pi/2));
    funcgrip(1).model.plot3d([0 0 0],'notiles','nowrist','noarrow','scale',0.25,'alpha',0);

    funcgrip(2)=Robotiq2F85(tr.T*trotz(3*pi/2));
    funcgrip(2).model.plot3d([0 0 0],'notiles','nowrist','noarrow','scale',0.25,'alpha',0);



    for i=1:stepss    % Closing animation

        funcgrip(1).model.animate(closematrix(i,:));
        funcgrip(2).model.animate(closematrix(i,:));

    end

        delete(funcgrip);  %Once it is done, delete the serial link, and call to spawn static close model outside of function
     
      

        gripobj=Env('Environment\Mdl\LinearUR5\Robotiq2845close.ply','Static close Gripper',[0 0 0],1); %Spawn static close model to drag food
        gripobj.plot(robobj.model.fkine(robobj.model.getpos()).T);




elseif int==2     % Open gripper up and then delete, Must be spawned first
      
    delete(gripobj.handle);
    delete(gripobj);
    

     disp('***Dropping off item***');

    funcgrip(1)=Robotiq2F85(tr.T*trotz(pi/2));
    funcgrip(1).model.plot3d([0.5854    0.2232   -0.8128],'notiles','nowrist','noarrow','scale',0.25,'alpha',0);

    funcgrip(2)=Robotiq2F85(tr.T*trotz(3*pi/2));
    funcgrip(2).model.plot3d([0.5854    0.2232   -0.8128],'notiles','nowrist','noarrow','scale',0.25,'alpha',0);

    
    
    for i=1:stepss    % open matrix animation

        funcgrip(1).model.animate(openmatrix(i,:));
        funcgrip(2).model.animate(openmatrix(i,:));

    end

    delete(funcgrip); % Delete gripper 
    

    gripobj=Env('Environment\Mdl\LinearUR5\Robotiq2845Open.ply','Static Open Gripper',[0 0 0],1); %Spawn static open model to finish drag
    gripobj.plot(robobj.model.fkine(robobj.model.getpos()).T); 


end

end




if nargin==6
    incident=0;

elseif nargin==4
    error('Functions needs a model reference to pick up items');
end



if incident==0
    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);

elseif incident==1

    fprintf(' \n \n***INCIDENT *** \nUh oh, there has been a spill from the drinks. \n A cleaner will clean up the mess. \n STOP ROBOT\n');
    pause(5);
    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);

elseif incident==2
    fire= Env("Environment\Mdl\Safety\fire.ply","fire",[0 0 0],1);
    fire.plot(transl(-1.5,0,-0.5)*trotz(rad2deg(135)));
    fprintf(' \n \n***INCIDENT *** \nOh no, there is a fire in the kitchen \n A worker will put it out. \nSTOP ROBOT \nACTIVATE SPRINKLER\n');
    pause(5);
    
    delete(fire.handle);
    delete(fire);

    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);
    
elseif incident==3
    fprintf(' \n \n***INCIDENT *** \nNot again!, %s is angry and is trying to break into the robot zone. \n The police will escort the customer out \nSTOP ROBOT\n',custobj.Name);
    pause(5);
    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);

elseif incident==4
    fprintf(' \n \n***INCIDENT *** \n Oof, there is a power blackout \n An electrician will restore power\nSTOP ROBOT\n');
    pause(5);
    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);


end

% Instructions must be an array of joint positions
steps=25;       %50 traject steps for smoother animation

m=size(instruct);


trayplace=1;
fidx=1;

for idxx=1:m(1,1)

    if idxx==m(1,1)                                 %% USE MODEL REFERENCE TO DETERMINE POSITION OF FOOD ON TRAY
        disp('THIS IS A TEMPPPP!!');
        Start=instruct(idxx,:);
        End= instruct(1,1);

        qmatrix=jtraj(Start,End,steps);
        

        for j=1:steps
            robobj.model.animate(qmatrix(j,:));
            Tr= robobj.model.fkine(qmatrix(j,:)).T;
            transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
            set(gripobj.handle,'Vertices',transformedVertices(:,1:3));
        end


    else

        Start= instruct(idxx,:);
        End  = instruct(idxx+1,:);


        qmatrix=jtraj(Start,End,steps);



%____________________________PICKUP LARGE BURGER_______________________________________________________________________

        if ref(1,idxx)== 1 && ref(1,idxx+1)==0      
            
           
            grip(1,robobj.model.fkine(robobj.model.getpos()));  %Open up gripper for dragging                

            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;

                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));
                
                transformedVertices = [models(5).vertices,ones(size(models(5).vertices,1),1)] * Tr';
                set(models(5).handle,'Vertices',transformedVertices(:,1:3));
               
            end

            grip(2,robobj.model.fkine(robobj.model.getpos())); % Close gripper up and delete to conserve performance            
            
            handlec=models(5).handle;
            verts =models(5).vertices;
            model="Environment\Mdl\Restaurant\hamburgerLRG.ply";


%____________________________PICKUP REGULAR BURGER_______________________________________________________________________

        elseif ref(1,idxx)== 2 && ref(1,idxx+1)==0  
          
            grip(1,robobj.model.fkine(robobj.model.getpos()));  %Open up gripper for dragging
                                         
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;

                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));

                transformedVertices = [models(6).vertices,ones(size(models(6).vertices,1),1)] * (Tr * transl(0,0,0.05))';
                set(models(6).handle,'Vertices',transformedVertices(:,1:3));
            end

            

            grip(2,robobj.model.fkine(robobj.model.getpos())); % Close gripper up and delete to conserve performance

            handlec=models(6).handle;
            verts =models(6).vertices;
            model="Environment\Mdl\Restaurant\hamburger.ply";


%____________________________PICKUP FRIES_______________________________________________________________________


        elseif ref(1,idxx)== 3  && ref(1,idxx+1)==0 

            grip(1,robobj.model.fkine(robobj.model.getpos()));  %Open up gripper for dragging

            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                 
                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));

                transformedVertices = [models(7).vertices,ones(size(models(7).vertices,1),1)] * (Tr * transl(0,0,0.2)* trotx(pi))';
                set(models(7).handle,'Vertices',transformedVertices(:,1:3));

                
            end

            grip(2,robobj.model.fkine(robobj.model.getpos())); % Close gripper up and delete to conserve performance
            
        
            handlec=models(7).handle;
            verts =models(7).vertices;
            model="Environment\Mdl\Restaurant\fries.ply";

%____________________________PICKUP SODA_______________________________________________________________________

        elseif ref(1,idxx)== 4  && ref(1,idxx+1)==0  


            grip(1,robobj.model.fkine(robobj.model.getpos()));  %Open up gripper for dragging
            
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                
                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));

                transformedVertices = [models(8).vertices,ones(size(models(8).vertices,1),1)] * (Tr* transl(0,0,0.2) * trotz(pi))';
                set(models(8).handle,'Vertices',transformedVertices(:,1:3));

               
            end

            grip(2,robobj.model.fkine(robobj.model.getpos())); % Close gripper up and delete to conserve performance

            handlec=models(8).handle;
            verts =models(8).vertices;
            model="Environment\Mdl\Restaurant\sodacup.ply";


%____________________________ORDER HAS FINISHED_______________________________________________________________________

        elseif ref(1,idxx)==0 && ref(1,idxx+1)==0 % Order Finished

            disp('Order finished*************');
            Start=instruct(idxx,:);
            End= instruct(1,1);

            qmatrix=jtraj(Start,End,steps);

            for j=1:steps
                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine(qmatrix(j,:)).T;
                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));
                
            end
             
        
            break

%____________________________GENERAL MOVEMENT_______________________________________________________________________

        else                                
            
            disp('moving');   
           
          
            for j=1:steps           
                
                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine(qmatrix(j,:)).T;
                transformedVertices = [gripobj.vertices,ones(size(gripobj.vertices,1),1)] * Tr';
                set(gripobj.handle,'Vertices',transformedVertices(:,1:3));
               
              
            end

    

        end

    end



%__________________________________________________________________________________________________________
    % THIS IS WHERE THE FOODS ARE PLACED IN SPECIFIC POSITIONS ON THE TRAY
%__________________________________________________________________________________________________________

    if ref(1,idxx)>0 && ref(1,idxx+1)==0

        transformedVertices = [verts,ones(size(verts,1),1)] * (Tr * transl(0,0,0.5))';       % Models dissapears, to appear theyre dropped
        set(handlec,'Vertices',transformedVertices(:,1:3));



        if ref(1,idxx)==4 && ref(1,idxx+1)==0         % Fix bug where cup is not standing on tray

            Restobj(fidx)= Env(model,"temp",[0 0 0],1);
            Restobj(fidx).plot((transl(traypos(trayplace,1),traypos(trayplace,2),traypos(trayplace,3))*trotx(pi/2)));
            fidx=fidx+1;
        else

            Restobj(fidx)= Env(model,"temp",[0 0 0],1);
            Restobj(fidx).plot(transl(traypos(trayplace,1),traypos(trayplace,2),traypos(trayplace,3)));
            fidx=fidx+1;

        end




        if trayplace ==3
            trayplace=1;

        else
            trayplace= trayplace+1;
        end







    else

    end

end
    disp('Finished serving customer');



end


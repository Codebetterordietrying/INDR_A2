function  Restobj= RobDo(robobj,custobj,gripobj,models,instruct,ref,traypos, incident)

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

    fprintf(' \n \n***INCIDENT *** \nOh no, there is a fire in the kitchen \n A worker will put it out. \nSTOP ROBOT \nACTIVATE SPRINKLER\n');
    pause(5);
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
steps=50;       %50 traject steps for smoother animation

m=size(instruct);


trayplace=1; 
fidx=1;

for idxx=1:m(1,1)

    if idxx==m(1,1)                                 %% USE MODEL REFERENCE TO DETERMINE POSITION OF FOOD ON TRAY

        Start=instruct(idxx,:);
        End= instruct(1,1);

        qmatrix=jtraj(Start,End,steps);

            for j=1:steps
            robobj.model.animate(qmatrix(j,:));
            end


    else

        Start= instruct(idxx,:);
        End  = instruct(idxx+1,:);


        qmatrix=jtraj(Start,End,steps);

           
        if ref(1,idxx)== 1 && ref(1,idxx+1)==0      % Pickup Large Burger
            for j=1:steps
    
                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(5).vertices,ones(size(models(5).vertices,1),1)] * Tr';
                set(models(5).handle,'Vertices',transformedVertices(:,1:3));
                

            end

                handlec=models(5).handle;
                verts =models(5).vertices;
                model="Environment\Mdl\Restaurant\hamburgerLRG.ply"; 
             
                   

        elseif ref(1,idxx)== 2 && ref(1,idxx+1)==0  % Pickup Reg Buger
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(6).vertices,ones(size(models(6).vertices,1),1)] * (Tr * transl(0,0,0.05))';
                set(models(6).handle,'Vertices',transformedVertices(:,1:3));
              
            end

                handlec=models(6).handle;
                verts =models(6).vertices;
                model="Environment\Mdl\Restaurant\hamburger.ply"; 
               

        elseif ref(1,idxx)== 3  && ref(1,idxx+1)==0 %Pickup Fries
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(7).vertices,ones(size(models(7).vertices,1),1)] * (Tr * transl(0,0,0.2)* trotx(pi))';
                set(models(7).handle,'Vertices',transformedVertices(:,1:3));       
                
            end

                handlec=models(7).handle;
                verts =models(7).vertices;
                model="Environment\Mdl\Restaurant\fries.ply"; 
                


        elseif ref(1,idxx)== 4  && ref(1,idxx+1)==0  %Pickup Soda
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(8).vertices,ones(size(models(8).vertices,1),1)] * (Tr* transl(0,0,0.2) * trotz(pi))';
                set(models(8).handle,'Vertices',transformedVertices(:,1:3));
            
             
            end
                handlec=models(8).handle;
                verts =models(8).vertices;
                model="Environment\Mdl\Restaurant\sodacup.ply"; 
               


                
        elseif ref(1,idxx)==0 && ref(1,idxx+1)==0 % Order Finished
        Start=instruct(idxx,:);
        End= instruct(1,1);

        qmatrix=jtraj(Start,End,steps);

            for j=1:steps
            robobj.model.animate(qmatrix(j,:));
            end
            break

        else

            for j=1:steps
            robobj.model.animate(qmatrix(j,:));
            
            end
            
        end

    end




  % THIS IS WHERE THE FOODS ARE PLACED IN SPECIFIC POSITIONS ON THE TRAY  


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




end
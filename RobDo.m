function [Tr, Event, Done] = RobDo(robobj,custobj,models,instruct,ref,incident)

if nargin==5
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
    fprintf(' \n \n***INCIDENT *** \Oof, there is a power blackout \n An electrician will restore power\nSTOP ROBOT\n');
    pause(5);
    fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);


end

% Instructions must be an array of joint positions
steps=50;       %50 traject steps for smoother animation

m=size(instruct);



for idxx=1:m(1,1)

    if idxx==m(1,1)

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
                transformedVertices = [models(2).vertices,ones(size(models(2).vertices,1),1)] * Tr';
                set(models(2).handle,'Vertices',transformedVertices(:,1:3));
            end

        elseif ref(1,idxx)== 2 && ref(1,idxx+1)==0  % Pickup Reg Buger
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(3).vertices,ones(size(models(3).vertices,1),1)] * Tr';
                set(models(3).handle,'Vertices',transformedVertices(:,1:3));
            end

        elseif ref(1,idxx)== 3  && ref(1,idxx+1)==0 %Pickup Fries
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(4).vertices,ones(size(models(4).vertices,1),1)] * Tr';
                set(models(4).handle,'Vertices',transformedVertices(:,1:3));

            end

        elseif ref(1,idxx)== 4  && ref(1,idxx+1)==0  %Pickup Soda
            for j=1:steps

                robobj.model.animate(qmatrix(j,:));
                Tr= robobj.model.fkine  (qmatrix(j,:)).T;
                transformedVertices = [models(5).vertices,ones(size(models(5).vertices,1),1)] * Tr';
                set(models(5).handle,'Vertices',transformedVertices(:,1:3));

            end

        elseif ref(1,idxx)==0 && ref(1,idxx+1)==0 %POrder Finished
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

end

end


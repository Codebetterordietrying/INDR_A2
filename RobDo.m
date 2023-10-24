function [Tr, Event, Done] = RobDo(robobj,custobj,instruct,incident)

if nargin==3
  incident=0;
end


fprintf("\nRobot is getting order number: %i for %s \n",custobj.Order,custobj.Name);

% Instructions must be an array of joint positions   
steps=50;       %50 traject steps for smoother animation

m=size(instruct);

for idx=1:m(1,1)

if idx==m(1,1)

    Start=instruct(idx,:);
    End= instruct(1,1);

else 

    Start= instruct(idx,:);
    End  = instruct(idx+1,:);

end
qmatrix=jtraj(Start,End,steps);


    for j=1:steps

            robobj.model.animate(qmatrix(j,:));
        Tr= robobj.model.fkine  (qmatrix(j,:));

    end



end

end

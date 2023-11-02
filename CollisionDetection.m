%% Robotics
% Lab 5 - Questions 2 and 3: 3-link plannar collision check and avoidance
function [  ] = Lab5Solution_Question2( )

% clf
close all;

r = DensoVS068                    
q = zeros(1,6);                                                     % Create a vector of initial joint angles        
scale = 0.5;
workspace = [-2 2 -2 2 -0.05 2];                                       % Set the size of the workspace when drawing the robot
r.model.plot(q,'workspace',workspace,'scale',scale);                  % Plot the robot
% Section 1        
% 2.2 and 2.3
centerpnt = [0,0.5,0.4];
side = 0.25;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
axis equal
r.model.teach(q)
% Se
% 2.4: Get the transform of every joint (i.e. start and end of every link)
tr = zeros(4,4,r.model.n+1);
tr(:,:,1) = r.model.base;
L = r.model.links;
for i = 1 : r.model.n
    tr(:,:,i+1) = tr(:,:,i) * trotz(q(i)+L(i).offset) * transl(0,0,L(i).d) * transl(L(i).a,0,0) * trotx(L(i).alpha);
end



% 2.6: Go through until there are no step sizes larger than 1 degree
q1 = [0,1.5010,-1.4992,0.1955,0,0];
q2 = [2.0944,1.5010,-1.4992,0.1955,0, 0];
steps = 50;
qMatrix = jtraj(q1,q2,steps);


collisionOccurred = false;  % Initialize collision flag

for i = 1:steps
    % Check for collision at the next step (i+1)
    collisionOccurred = IsCollision(r, qMatrix(i+4,:), faces, vertex, faceNormals, true);

    if ~collisionOccurred
        % No collision, continue animating the robot
        r.model.animate(qMatrix(i+1,:));
    else
        % Collision detected, stop the robot
        r.model.animate(qMatrix(i,:)); % Stop at the current step
        break; % Exit the loop
    end
end

end


% IsIntersectionPointInsideTriangle
% Given a point which is known to be on the same plane as the triangle
% determine if the point is 
% inside (result == 1) or 
% outside a triangle (result ==0 )
function result = IsIntersectionPointInsideTriangle(intersectP,triangleVerts)

u = triangleVerts(2,:) - triangleVerts(1,:);
v = triangleVerts(3,:) - triangleVerts(1,:);

uu = dot(u,u);
uv = dot(u,v);
vv = dot(v,v);

w = intersectP - triangleVerts(1,:);
wu = dot(w,u);
wv = dot(w,v);

D = uv * uv - uu * vv;

% Get and test parametric coords (s and t)
s = (uv * wv - vv * wu) / D;
if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
    result = 0;
    return;
end

t = (uv * wu - uu * wv) / D;
if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
    result = 0;
    return;
end

result = 1;                      % intersectP is in Triangle
end

% IsCollision
% This is based upon the output of questions 2.5 and 2.6
% Given a robot model (robot), and trajectory (i.e. joint state vector) (qMatrix)
% and triangle obstacles in the environment (faces,vertex,faceNormals)
function result = IsCollision(r,qMatrix,faces,vertex,faceNormals,returnOnceFound)
if nargin < 6
    returnOnceFound = true;
end
result = false;

for qIndex = 1:size(qMatrix,1)
    % Get the transform of every joint (i.e. start and end of every link)
    tr = GetLinkPoses(qMatrix(qIndex,:), r);

    % Go through each link and also each triangle face
    for i = 1 : size(tr,3)-1    
        for faceIndex = 1:size(faces,1)
            vertOnPlane = vertex(faces(faceIndex,1)',:);
            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
            if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
                display('Intersection');
                result = true;
                if returnOnceFound
                    return
                end
            end
        end    
    end
end
end 



function [ transforms ] = GetLinkPoses( q, r)

links = r.model.links;
transforms = zeros(4, 4, length(links) + 1);
transforms(:,:,1) = r.model.base;

for i = 1:length(links)
    L = links(1,i);

    current_transform = transforms(:,:, i);

    current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
    transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
    transforms(:,:,i + 1) = current_transform;
end
end

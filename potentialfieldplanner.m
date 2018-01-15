nrows = 400;
ncols = 600;
obstacle = false(nrows, ncols);
[x, y] = meshgrid (1:ncols, 1:nrows);
obstacle (200:end, 100:450) = true;
obstacle (190:200, 450:600) = true;
t = ((x - 200).^2 + (y - 50).^2) < 50^2;
obstacle(t) = true;
t = ((x - 400).^2 + (y - 300).^2) < 100^2;
obstacle(t) = true;
d = bwdist(obstacle);
d2 = (d/100) + 1;
d0 = 2;
nu = 800;
repulsive = nu*((1./d2 - 1/d0).^2);
repulsive (d2 > d0) = 0;
figure(1);
m = mesh (repulsive);
m.FaceLighting = 'phong';
axis equal;
goal = [400, 500];
xi = 1/700;
attractive = xi * ( (x - goal(1)).^2 + (y - goal(2)).^2 );
figure(2);
m = mesh (attractive);
m.FaceLighting = 'phong';
axis equal;
title ('Attractive Potential');
figure(3);
imshow(~obstacle);

hold on;
plot (goal(1), goal(2), 'r.', 'MarkerSize', 25);
hold off;

axis ([0 ncols 0 nrows]);
axis xy;
axis on;

xlabel ('x');
ylabel ('y');

title ('Configuration Space');
f = attractive + repulsive;
figure(4);
m = mesh (f);
m.FaceLighting = 'phong';
axis equal;

title ('Total Potential');
start = [100, 150];
route=planner(f,start,goal,1000);
figure(5);
m = mesh (f);
axis equal
[sx, sy, sz] = sphere(20);
scale = 20;
sx = scale*sx;
sy = scale*sy;
sz = scale*(sz+1);

hold on;
p = mesh(sx, sy, sz);
p.FaceColor = 'red';
p.EdgeColor = 'none';
p.FaceLighting = 'phong';
hold off;

for i = 1:size(route,1)
    P = round(route(i,:));
    z = f(P(2), P(1));
    
    p.XData = sx + P(1);
    p.YData = sy + P(2);
    p.ZData = sz + f(P(2), P(1));
    
    drawnow;
    
    drawnow;
    
end

%% quiver plot
[gx, gy] = gradient (-f);
skip = 20;

figure(6);

xidx = 1:skip:ncols;
yidx = 1:skip:nrows;

quiver (x(yidx,xidx), y(yidx,xidx), gx(yidx,xidx), gy(yidx,xidx), 0.4);

axis ([1 ncols 1 nrows]);

hold on;

ps = plot(start(1), start(2), 'r.', 'MarkerSize', 30);
pg = plot(goal(1), goal(2), 'g.', 'MarkerSize', 30);
p3 = plot (route(:,1), route(:,2), 'r', 'LineWidth', 2);

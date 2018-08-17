function route=planner(f,start,finish,numits)
[gx gy]=gradient(-f);
route=start;
pos=start;
flag=true;
i=0;
while flag
    if (i==numits) || (norm(finish-pos)<2)
        flag=false;
        break;
    end
    delta=[gx(round(pos(2)),round(pos(1))),gy(round(pos(2)),round(pos(1)))];
    pos=pos+delta/norm(delta);
    route=[route;pos];
    i=i+0.5;
end
end
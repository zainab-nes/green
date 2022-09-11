function [ nodes ] = Discovery( nodes )
for i = 1:100
    for j=1:40
       if i ~= j
           distance=sqrt((nodes.node(i).x - nodes.node(j).x)^2 + (nodes.node(i).y - nodes.node(j).y)^2);
 %          nodes.node(j).energy = nodes.node(j).energy -1.5;
           if(distance < nodes.node(i).R)
               nodes.node(i).NumIntNeighbors=nodes.node(i).NumIntNeighbors+1;
               nodes.node(i).intNeighbors(nodes.node(i).NumIntNeighbors)=j;
           else if (nodes.node(i).R < distance && distance < 2*nodes.node(i).R)
                nodes.node(i).NumExtNeighbors=nodes.node(i).NumExtNeighbors+1;
                nodes.node(i).extNeighbors(nodes.node(i).NumExtNeighbors)=j;  
               end
           end
       end
    end
%    nodes.node(i).energy = nodes.node(i).energy -1.9;
end
end


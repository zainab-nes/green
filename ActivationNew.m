function [ network, nodes ] = ActivationNew(  network, nodes , node ,time  )

if nodes.node(node).state ~= 'D'
    return;
end

network.transaction = network.transaction + 1;
nodes.node(node).state = 'A';
%change mode energy
nodes.node(node).energy = nodes.node(node).energy - 0.6;
%increase the number of ctive nodes
nodes.Activenodes = nodes.Activenodes+1;

for i=1:(nodes.node(node).NumIntNeighbors)
    index=nodes.node(node).intNeighbors(i);
    if nodes.node(index).state == 'D'
        %disp(index);
        [ network, nodes ] = check( network , nodes , index ,time , 0 );
        %disp(nodes.node(index).state);
    end
end


for i=1:(nodes.node(node).NumExtNeighbors)
    index=nodes.node(node).extNeighbors(i);
    if nodes.node(index).state == 'D' && nodes.node(index).x < nodes.node(node).x && nodes.node(index).y < nodes.node(node).y 
        nodes.node(index).queue(1) = nodes.node(index).queue(1) + 1;    
    else if nodes.node(index).state == 'D' && nodes.node(index).x < nodes.node(node).x && nodes.node(index).y > nodes.node(node).y 
        nodes.node(index).queue(4) = nodes.node(index).queue(4) + 1;
        end
    end
    if nodes.node(index).state == 'D' && nodes.node(index).x > nodes.node(node).x && nodes.node(index).y < nodes.node(node).y
        nodes.node(index).queue(2) = nodes.node(index).queue(2) + 1;
    else if nodes.node(index).state == 'D' && nodes.node(index).x > nodes.node(node).x && nodes.node(index).y > nodes.node(node).y
        nodes.node(index).queue(3) = nodes.node(index).queue(3) + 1;
        end
    end
    
    if nodes.node(index).state == 'D' &&(( nodes.node(index).queue(1) > 0 && nodes.node(index).queue(3) > 0) ...
            ||( nodes.node(index).queue(4) > 0 && nodes.node(index).queue(2) > 0))
       % disp(nodes.node(index).state);
        [ network, nodes ] = CRA( network , nodes , index ,time , 1 );
        
    end    
end


end


function [ network, nodes ] = dissipatedEnergy( network, nodes )
 for i=1:network.n
       if (nodes.node(i).state == 'A' || nodes.node(i).state == 'E' ...
                ) &&  nodes.node(i).energy > 0
           nodes.node(i).energy = nodes.node(i).energy - network.IdlePower;
       else if nodes.node(i).state == 'S'  &&  nodes.node(i).energy > 0 
           nodes.node(i).energy = nodes.node(i).energy - network.SleepPower;
           end
       end
       if nodes.node(i).energy < network.Excasted &&   nodes.node(i).state == 'A' 
           nodes.node(i).state = 'E';
           network.transaction = network.transaction + 1;
           nodes.node(i).energy = nodes.node(i).energy - 0.6;
           nodes.E = nodes.E + 1;
           nodes.Activenodes = nodes.Activenodes - 1;
         %  [ network, nodes ] = ActiveToEx( network, nodes ,i );
       end
       if  nodes.node(i).energy <= 0 && nodes.node(i).state == 'E'
%            [ network  ] = cover(  network , nodes );
           nodes.node(i).energy = 0;
           nodes.E=nodes.E-1;
           nodes.dead = nodes.dead +1;
           nodes.node(i).state ='d';
       end
  end
end


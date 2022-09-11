function [ network, nodes ] = Check( network , nodes , node ,time , flag)
    
    if nodes.node(node).state ~= 'D' 
      return;
    end

    X = nodes.node(node).x;
    Y = nodes.node(node).y;
   
    x = round(X - 20);
    y = round(Y - 20);
    
    maxX = round(X + 20); 
    maxY = round(Y + 20); 
    
    
    if x < 1
        x=1;
    end
    
    if maxX > network.area.Length
            maxX=network.area.Length;
    end
         
    if maxY > network.area.Length
            maxY=network.area.Length;
    end
    
    nodes.node(node).energy = nodes.node(node).energy - network.CRA;
    network.numCRA = network.numCRA + 1;
    
    counter=1;

    cover = struct;
    flag1=0;
    while x <= maxX
        if flag1==1;
        	break;
        end
        y = round(Y - 20);
        if y < 1
            y=1;
        end
        while y <= maxY
           distance=sqrt((X - x)^2 + (Y - y)^2);
           if(distance < nodes.node(node).R )
               if network.cover(x,y) < 2
%                  
                   if(flag == 0)
                       return;
                   end
                   flag1=1;
                   break;
               end
               cover(counter).x=x;
               cover(counter).y=y;
               counter=counter+1;
           end
           y=y+1;
        end 
        x=x+1;
    end
    if (flag1 == 1 ) 
         [ network, nodes ] = Activation(  network, nodes , node ,time  );
        
    else    
        
        counter = counter -1;
        for j=1:counter
            network.cover(cover(j).x, cover(j).y) =...
                network.cover(cover(j).x,cover(j).y) - 1;
            
        end
        % something 
        minEnergy=network.initE+1;
        for j=1:(nodes.node(node).NumIntNeighbors)
            index=nodes.node(node).intNeighbors(j);
            if minEnergy > nodes.node(index).energy && nodes.node(index).energy > network.Excasted ...
                    && nodes.node(index).state ~= 'E' && nodes.node(index).state ~= 'S' 
                minEnergy=nodes.node(index).energy;
            end
        end

        nodes.node(node).wakeUp=ceil(time + ((minEnergy - network.Excasted)/network.IdlePower));
        
        nodes.Sleepnodes = nodes.Sleepnodes+1;
        nodes.SleepTime(node)=nodes.node(node).wakeUp;
        network.transaction = network.transaction+1;
        nodes.node(node).state = 'S';
        %for change state
        nodes.node(node).energy = nodes.node(node).energy - 0.6;
        %disp(node);
    end
end


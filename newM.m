function [ network, nodes ] = newM( network , nodes , node ,time , flag)
    
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
    
    nodes.node(node).energy = nodes.node(node).energy - network.check;
    network.check = network.check + 1;
    
    counter=1;

    cover = struct;
    flag1=2;
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
               elseif network.cover(x,y) == 2 
                   flag1=0;
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
         %disp(node);
    elseif flag1 == 0    
        %disp(time);
        counter = counter -1;
        for j=1:counter
            network.cover(cover(j).x, cover(j).y) =...
                network.cover(cover(j).x,cover(j).y) - 1;
            
        end
        % something larger than init energy
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
    else
        %disp(time);
        counter = counter -1;
        for j=1:counter
            network.cover(cover(j).x, cover(j).y) =...
                network.cover(cover(j).x,cover(j).y) - 1;
            
        end
        
        minActEnergy=network.initE+1;

        for j=1:(nodes.node(node).NumIntNeighbors)
            index=nodes.node(node).intNeighbors(j);
            if minActEnergy > nodes.node(index).energy && nodes.node(index).energy > network.Excasted ...
                    && nodes.node(index).state ~= 'E' && nodes.node(index).state ~= 'S' 
                minActEnergy=nodes.node(index).energy;
                
            end
        end

        actTpEx = (minActEnergy - network.Excasted)/network.IdlePower;
        minEnergy = network.initE +1;
        for j=1:(nodes.node(node).NumIntNeighbors)
            index=nodes.node(node).intNeighbors(j);
            if minEnergy > nodes.node(index).energy && nodes.node(index).energy > network.Excasted ...
                    && nodes.node(index).state == 'D' 
                minEnergy=nodes.node(index).energy;
            end
        end
        forward=S(node).pf;
        backword=S(node).pb;
        SPath=0;
        for i=1:1:size(S.N(:,1))
        if S(i).M==1 || S(i).mhop <=2
            S(i).ETX=1/(forward * backword);
        end
        path=(0);
        for j=1:1:Npath
            path.j= S(node).ETX +S(S.N(:,1)).ETX;
        if path(1,1) < path.j
            Cs=S(node);
            S(node).EAX=path.j;
        end
        end
        end
        minEAX=S.N(1,1);
        for j=1:1:Npath
        if S(node).EAX < minEAX
            minEAX=S(node).EAX;
        end
        for i=1:1:size(S.N(:,1))
    
            minhop= min (S(node).hop);
        if S(node.minhop).EAX == minEAX
            SPath=S(i).EAX;
        else
        for r=1:1:size(S.N(:,1))
             x=S(r).hop;
                y = S(r).EAX;
            if x > S(r.minhop) && y <= minEAX
                SPath=S(r).EAX;
            end
        end
        end
        end
        end
        minEnergy = minEnergy -  actTpEx * network.SleepPower;
        nodes.node(node).wakeUp = ceil(time + actTpEx + ((minEnergy - network.Excasted)/network.IdlePower));
%         (actTpEx * network.SleepPower)
%         minEnergy
%         (time + actTpEx + ((minEnergy - network.Excasted)/network.IdlePower))
        nodes.Sleepnodes = nodes.Sleepnodes+1;
        nodes.SleepTime(node)=nodes.node(node).wakeUp;
        network.transaction = network.transaction+1;
        nodes.node(node).state = 'S';
        
    nodes.node(node).SPath = SPath;
        %for change state
        nodes.node(node).energy = nodes.node(node).energy - 0.6;
        %disp(node);
    end
end




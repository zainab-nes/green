clear all ; 
clc;

%create network for new protocol
networkNew = CreateNetwork();

networkNew = Kcover( networkNew , nodesNew );
%discovre the niegbores in New nodes
nodesNew   = Discovery( nodesNew );


%first excute of algorithem to all nodes 
for i=1:225
    [ networkNew ,nodesNew ]    = Mobile(networkNew , nodesNew , i , 0 , 1);
    end 


%first excute of algorithem to all nodes 
for i=1:225
       [ networkNew ,nodesNew ]     = green(networkNew , nodesNew , i , 0 , 1);
end 

for j=1:networkNew.n
    node = 0 ;
    maxEnergy = -1;
    for i=1:networkNew.n
        if nodesNew(i).state == 'D' && nodesNew.node(i).energy > maxEnergy
            maxEnergy = nodesNew.node(i).energy ;
            node = i; 
        end
    end  
    %no nodes in Discovery state
    if node == 0
        break;
    end
    [networkNew , nodesNew ] = Activation( networkNew , nodesNew , node ,0 );
end
  [networkSECWP , nodesSECWP ] = Activation( networkSECWP , nodesSECWP , node ,0 );
for j=1:networkSECWP.n
    node = 0 ;
    maxEnergy = -1;
    for i=1:networkSECWP.n
        if nodesSECWP.node(i).state == 'D' && nodesSECWP.node(i).energy > maxEnergy
            maxEnergy = nodesSECWP.node(i).energy ;
            node = i; 
        end
    end  
    %no nodes in Discovery state
    if node == 0
        break;
    end
    [networkSECWP, nodesSECWP ] = ActivationSECWP( networkSECWP, nodesSECWP , node ,0 );
end

%find the minimunm time of change the state of sleep node 
%to back to discovery state 
minSleepTimeNew=min(nodesNew.SleepTime);
par3 = struct;


for time=1:1000
    time
    %function to calculate the dissipated Energy 
    %depand on the node state 
    
    [ networkNew, nodesNew ] = dissipatedEnergy( networkNew, nodesNew );
    

    %if it's the time to change state of the sleep node for the SPECIFIC  nodes
    if minSleepTimeSPEC == time
        for j=1:networkSPEC.n
            %find the sleep node that it's wakup time is the current time 
            if nodesSPEC.node(j).state == 'S' && nodesSPEC.node(j).wakeUp == minSleepTimeSPEC
             %change the state to discovery 
                nodesSPEC.node(j).state = 'D';
                nodesSPEC.node(j).wakeUp = 0;
            
                nodesSPEC.node(j).queue(1)=0;
                nodesSPEC.node(j).queue(2)=0;
                nodesSPEC.node(j).queue(3)=0;
                nodesSPEC.node(j).queue(4)=0;
              %decreace the number of sleep nodes
                nodesSPEC.Sleepnodes = nodesSPEC.Sleepnodes - 1;
            end
        end
         for j=1:length(nodesSPEC.SleepTime)
            if nodesSPEC.SleepTime(j) == minSleepTimeSPEC
                nodesSPEC.SleepTime(j)=10000;
            end
        end
        
        %calculate the cover for the network after change the node state
        networkSPEC = cover( networkSPEC , nodesSPEC );
        %run the activation functions
        for j=1:networkSPEC.n
            [networkSPEC, nodesSPEC ] = Activation( networkSPEC, nodesSPEC , j , time);
        end
      
        i;
        minSleepTimeSPEC = min(nodesSPEC.SleepTime);
    end
    
  
    if minSleepTimeSECWP == time
        for j=1:networkSECWP.n
         
            if nodesSECWP.node(j).state == 'S' && nodesSECWP.node(j).wakeUp == minSleepTimeSECWP
               %change the state to discovery for dormant node
                nodesSECWP.node(j).state = 'D';
                
                nodesSECWP.node(j).wakeUp = 0;
                nodesSECWP.node(j).queue(1)=0;
                nodesSECWP.node(j).queue(2)=0;
                nodesSECWP.node(j).queue(3)=0;
                nodesSECWP.node(j).queue(4)=0;
              
                nodesSECWP.Sleepnodes = nodesSECWP.Sleepnodes - 1;
            end
        end
       
        for j=1:length(nodesSECWP.SleepTime)
            if nodesSECWP.SleepTime(j) == minSleepTimeSECWP
                nodesSECWP.SleepTime(j)=10000;
            end
        end
        
        networkSECWP = Kcover( networkSECWP , nodesSECWP );
        %run the activation functions
        for j=1:networkSECWP.n
            [networkSECWP, nodesSECWP ] = ActivationSECWP( networkSECWP, nodesSECWP , j , time);
        end

        i;
        
        minSleepTimeSECWP = min(nodesSECWP.SleepTime);
    end
    

    par1 = plotResults( networkSPEC, nodesSPEC , time, par1 ); 
    par2 = plotResults( networkSECWP, nodesSECWP , time, par2 ); 
    if par1.energy(time)== 0 && par2.energy(time)== 0
        break;
    end
    
end

createFigure( 1:time , par1 , par2);





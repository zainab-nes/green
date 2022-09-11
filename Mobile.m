clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

global BestFit;
global BestSol;
global FitAccess;
global count;
%Field Dimensions - x and y maximum (in meters)
xm=100;
ym=100;

% x and y Coordinates of the Sink
% Sink Position
sink.x=xm;
sink.y=ym;

%Number of Nodes in the field
n=100;

%maximum number of rounds
rmax=2000;


%Optimal Election Probability of a node
%to become cluster head
p=0.1;
p_a=0.1;
a=1;

%%      INITIALIZATION

do=sqrt(Efs/Emp);

 
% Variable 'S' denotes 'Sensor'
S.xd=[];
S.yd=[];
S.G=[];
S=repmat(S,n,1);
XR=repmat([],n,1);   
YR=repmat([],n,1);   
PACKETS_TO_CH_P_R=repmat([],rmax,1);   
PACKETS_TO_BS_P_R=repmat([],rmax,1);
STATISTICS=repmat([],n,1);
DEAD=repmat([],n,1);     


cla;   
axis([0 xm 0 ym]); 
hold on

  %% Mobility Range
  r=0;
  m1=0.01+(slider1_data.val/100);
  aa=-1;
  ba=1;
  o1=[S(1:n).xd];
  o2=[S(1:n).yd];
  x = aa + (ba-aa)*rand(1,n);
  x1 = aa + (ba-aa)*rand(1,n);
  
  o11=o1+(r+1).*x.*m1;
  o21=o2+(r+1).*x1.*m1;
 
  for i=1:n
      if (o11(i)<xm && o21(i)<ym && o11(i)>0 && o21(i)>0)
         S(i).xd=o11(i); 
         S(i).yd=o21(i);
      end
  end
  
 for i=1:n   
 
    temp_rnd0=i;
   
    % Nodes with sign 'o' are Normal nodes, which have less energy level
    if (temp_rnd0>=p_a*n+1) 
        S(i).E=Eo;             % This variable represents the node's Energy
        S(i).ENERGY=0;   % This represents, whether node is advance or normal
      
        
    end
   
    % Nodes with sign '+' are Advance nodes, which have more energy level
    if (temp_rnd0<p_a*n+1)  
        S(i).E=Eo*(1+a);
        S(i).ENERGY=1;
      
      
    end
    
end    


countCHs=0;
%counter for CHs per round
rcountCHs=0;
cluster=1;

%countCHs
rcountCHs=rcountCHs+countCHs;
flag_first_dead=0;

% r=Round
% rmax= maximum Number Of Rounds
%r=0:1:rmax => mean for loop from 0 to 3500 with 1 increase in each step
for r=0:1:rmax
   
    
    % print value of 'r' in each Iteration
    r
    
   
    za=10/(slider_data.val+0.001);
        pause(za)
    
   
    %Operation for epoch
    % (r mod 1/p) is the most recent round; (r mod 1/p) becomes zero when the round is starting.
    % Setting all the nodes 'G' and 'cl' to zero when the round is starting
    % or when the algorithm begins
  if(mod(r, round(1/p))==0)    
    for i=1:1:n
        % G is the set of nodes that weren't cluster-heads the previous round. 
        S(i).G=0;    
        % Variable for recognizing which cluster, Sensor i belong
        S(i).cl=0;    
    end
  end


  

%Number of dead nodes
dead=0;
%Number of dead Advanced Nodes
dead_a=0;
%Number of dead Normal Nodes
dead_n=0;

%counter for transmitted bits to Base Station and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
%counter for transmitted bits to Bases Station and to Cluster Heads 
%per round
% why (r+1)? because the index in MATLAB starts from 1
PACKETS_TO_CH_P_R(r+1)=0;   
PACKETS_TO_BS_P_R(r+1)=0;

%hold off;


%axis([0 xm 0 ym]);
%hold on;

%%            CHECKING FOR DEAD NODES
for i=1:1:n
    %checking if there is a dead node or not
    if (S(i).E<=0)      % mean node has no energy or if node is dead
        dead=dead+1;      % increase the overall dead sensors by one
        if(S(i).ENERGY==1)  % The dead sensor belong to Advance nodes
            dead_a=dead_a+1;
        end
        if(S(i).ENERGY==0)      % The dead sensor belong to normal nodes
            dead_n=dead_n+1;
        end
        hold on;    
    end
  
  end


STATISTICS(r+1).DEAD=dead;       
DEAD(r+1)=dead;      
DEAD_N(r+1)=dead_n; 
DEAD_A(r+1)=dead_a;  
if (dead==1)
    if(flag_first_dead==0)     
        first_dead=r;
        flag_first_dead=1;
    end
end



%%  CHOOSING CLUSTER HEADS WITH GENETIC ALGORITHM


[BestChrom,BF(r+1,1)]=GeneticAlgorithm(S,sink);


C=[];
countCHs=0;
cluster=1;
for i=1:n
    if (BestChrom(i)==1)
        
        countCHs=countCHs+1;
        packets_TO_BS=packets_TO_BS+1; 
        PACKETS_TO_BS_P_R(r+1)=packets_TO_BS;   
        S(i).type='C';
        C(cluster).xd=S(i).xd;
        C(cluster).yd=S(i).yd;
        distance=sqrt( (S(i).xd-(sink.x) )^2 + (S(i).yd-(sink.y) )^2 );
        C(cluster).distance=distance;
        C(cluster).id=i;
        X(cluster)=S(i).xd;  
        Y(cluster)=S(i).yd;  

        cluster=cluster+1;

        if (distance>do)
            S(i).E=S(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
        end
        if (distance<=do)
            S(i).E=S(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
        end
        
    end
end
STATISTICS(r+1).CLUSTERHEADS=cluster-1;
CLUSTERHS(r+1)=cluster-1;



%% Election of Associated Cluster Head for Normal Nodes
 for i=1:1:n
   if(cluster-1>=1)
     if ( S(i).type=='N' && S(i).E>0 )  %  Are you a normal node and have energy?
         %if(cluster-1>=1)    % checking for existence of CH
         % find the distance between sensor i and base station
         %MIN_dis=sqrt((S(i).xd-sink.x)^2 + (S(i).yd-sink.y)^2);
         MIN_dis=inf;
         % min_dis_cluster=1;
        for c=1:1:cluster-1
            CH_dis=sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 );
            % min_dis=min(BS_dis,CH_dis);
            % we want to find the minimum distance from Normal sensor i to any
            % CH rather than base station.
            if ( CH_dis < MIN_dis )
               MIN_dis=CH_dis;
               min_dis_cluster=c;
            end
        end
       
        % Energy dissipated by associated Cluster Head
            MIN_dis;
            if (MIN_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( MIN_dis * MIN_dis * MIN_dis * MIN_dis)); 
            end
            if (MIN_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( MIN_dis * MIN_dis)); 
            end
        if(MIN_dis>0)
          S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
         PACKETS_TO_CH_P_R(r+1)=n-dead-cluster+1; 
        end

       S(i).min_dis=MIN_dis;
       S(i).min_dis_cluster=min_dis_cluster;
     
      %end 
     end
   end
   
 end

countCHs;
rcountCHs=rcountCHs+countCHs;
cluster

% Mobilizing sensor nodes
for i=1:n
d=randi([1 4],1,1);
switch d
    case {1}
        
    case {2}
        
    case {3}
        
    case {4}
        
end
%}

%% Mobility Range

  m1=0.01+(slider1_data.val/100);
  aa=-1;
  ba=1;
  o1=[S(1:n).xd];
  o2=[S(1:n).yd];
  x = aa + (ba-aa)*rand(1,n);
  x1 = aa + (ba-aa)*rand(1,n);
  
  o11=o1+(r+1).*x.*m1;
  o21=o2+(r+1).*x1.*m1;
  ReEnergy(r+1,1)=0;  
  for i=1:n
      if (o11(i)<xm && o21(i)<ym && o11(i)>0 && o21(i)>0)
         S(i).xd=o11(i); 
         S(i).yd=o21(i);
      end
      %remained energy in each round 
      ReEnergy(r+1,1)=ReEnergy(r+1,1)+S(i).E;
  end

  
end





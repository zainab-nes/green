%  Green Communication %
clc
clear all;
close all;
xm=200;
ym=200;
sink.x=0.5*xm;
sink.y=0.5*ym;
%sink.x=100;
%sink.y=75;

n=100;
m=30;
p=0.1;
Eo=0.25;
EMo=10;
ETX=50*0.000000001;
ERX=50*0.000000001;
Efs=10e-12;
Emp=0.0013e-12;
EDA=5*0.000000001;
rmax=1000;
do=sqrt(Efs/Emp);
Et=0;
EtM=0;
Buffer=4;%Packets
PS=2000;%bit
Throuput=54;%Mb/s
Etotal=25;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%CH                               %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
for h=1:1
    S(n+1).xd=sink.x;
    S(n+1).yd=sink.y;
    Et=0;
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
    S(i).distance=distance;
    S(i).G=0;
    S(i).R=30;
    S(i).hop=0;
    S(i).id=i;
    S(i).Nid=zeros(0);
        S(i).NumIntNeighbors=0;
        S(i).N= [0,0,0];
        S(i).M=0;
     S(i).NC=0;
    %%%
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=0.25;
    S(i).v=0;
    Et=Et+S(i).E;
    figure(h*10)
      plot(S(i).xd,S(i).yd,'bo');
      text(S(i).xd+1,S(i).yd-0.5,num2str(i));
      hold on;
end

    for y=1:1:m
    M(y).xd=rand(1,1)*xm;
    MR(y)=M(y).xd;
    M(y).yd=rand(1,1)*ym;
    MR(y)=M(y).yd;
    distance=sqrt( (M(y).xd-(S(n+1).xd) )^2 + (M(y).yd-(S(n+1).yd) )^2 );
    M(y).distance=distance;
    M(y).G=0;
    M(y).R=30;
    M(y).type='M';
    M(y).E=EMo;
    
        M(y).NumIntNeighbors=0;
        M(y).N=[0];
    EtM=EtM+M(y).E;
    figure(h*10)
      plot(M(y).xd,M(y).yd,'-mo' ,...
    'LineWidth',2,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10) ;
      text(M(y).xd+1,M(y).yd-0.5,num2str(y));
      hold on;
    end
plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
text(S(n+1).xd+1,S(n+1).yd-0.5,num2str(n+1));
hold off ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countCHs=0;  %variable, counts the cluster head
cluster=1;  %cluster is initialized as 1
flag_first_dead=0; %flag tells the first node dead
flag_half_dead=0;  %flag tells the 10th node dead
flag_all_dead=0;  %flag tells all nodes dead
first_dead=0;
half_dead=0;
all_dead=0;
allive=n;
%counter for bit transmitted to Bases Station and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
packets_TO_BS_per_round=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
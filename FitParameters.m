function [TD,RCSD,CL,Nin,Nout,Ninc]=FitParameters(sink,S,popPos,Nin,Nout,Ninc)

    nVar=size(S,1);
    % Total distance of all nodes with BS.
    td=0; % Total distance of all sensor nodes with Base Station.
    dis=0;
    cluster=1;
    rcsd=0; 
    distance=0;
    for j=1:1:nVar
        dis=sqrt( (S(j).xd-(sink.x) )^2 + (S(j).yd-(sink.y) )^2 );
        td=td+dis;
        if (popPos(j)==1)
            C(cluster).xd=S(j).xd;
            C(cluster).yd=S(j).yd;
            C(cluster).distance=dis;
            S(j).type='C';
            cluster=cluster+1;
            disAv= sum (dis-S(J).dis)/100;
        end 
    end
    
    % Try to find minimum distance closest CH, among all CHs.
    
    if (cluster>1)
        for j=1:nVar
            mindis=inf;
          if (S(j).type ~= 'C')
            for c=1:cluster-1
                distance=sqrt((S(j).xd-(C(c).xd))^2 + (S(j).yd-(C(c).yd))^2)+1/ disAv;
                if (distance < mindis)
                    mindis=distance;
                end
            end

          if (mindis ~=inf)
             rcsd=rcsd+mindis;
          end
         end  
        end
    %Add base station's distance to rcsd.
        for c=1:cluster-1    
            rcsd=rcsd+C(c).distance;    
        end
    else
         rcsd=td;
    end  
     if (cluster>1)
        for j=1:nVar
            mindis=inf;
          if (S(j).type ~= 'N')
            for N=1:100
                S(j).EinRound= S(j).E/ S.(j).E0 ;
                EF=S(j).EinRound;
            end
            end
        end
     end
     if (cluster>1)
        for j=1:nVar
            mindis=inf;
          if (S(j).type ~= 'N')
            for N=1:100
                FC=Nin-(Nout+Ninc)/N;
            end
            end
        end
     end
    if (cluster>1)
        for j=1:nVar
            mindis=inf;
          if (S(j).type ~= 'N')
            for N=1:100
                
            end
            end
        end
     end
    
TD=td;          % Total distance
RCSD=rcsd;
E=EF;
CL=cluster-1;   % Number Of cluster heads
end
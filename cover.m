function [ network ] = cover(  network , nodes )
network.totalCover = zeros(100,100);
for i = 1:network.area.Length
    for j = 1:network.area.Width
        for n = 1:network.n
            distance=sqrt((nodes.node(n).x - i)^2 + (nodes.node(n).y - j)^2);
            if((nodes.node(n).state == 'E' || nodes.node(n).state == 'A') && distance <= nodes.node(n).R )
                network.totalCover(i,j)=network.totalCover(i,j)+1;
            end
        end
    end
end


% function [ networkSPEC, networkSECWP, networkNew  ] = cover(  networkSPEC , nodesSPEC  , networkSECWP, nodesSECWP ,networkNew , nodesNew )
% %COVER Summary of this function goes here
% % %   Detailed explanation goes here
% % networkSPEC = cover( networkSPEC , nodesSPEC );
% %     networkSECWP = cover( networkSECWP, nodesSECWP  );
% %     networkNew = cover( networkNew , nodesNew );
% networkSPEC.totalCover = zeros(100,100);
% networkSECWP.totalCover = zeros(100,100);
% networkNew.totalCover = zeros(100,100);
% for i = 1:networkSPEC.area.Length
%     for j = 1:networkSPEC.area.Width
%         for n = 1:networkSPEC.n
%             if(nodesSPEC.node(n).state == 'E' || nodesSPEC.node(n).state == 'A' )
%                 networkSPEC.totalCover(i,j)=networkSPEC.totalCover(i,j)+1;
%             end
%             if(nodesSECWP.node(n).state == 'E' || nodesSECWP.node(n).state == 'A' )
%                 networkSECWP.totalCover(i,j)=networkSECWP.totalCover(i,j)+1;
%             end
%             if(nodesNew.node(n).state == 'E' || nodesNew.node(n).state == 'A' )
%                 networkNew.totalCover(i,j)=networkNew.totalCover(i,j)+1;
%             end
%         end
%     end
% end
% 
% end
% 


end


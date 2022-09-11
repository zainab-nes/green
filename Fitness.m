function z=Fitness(N,TD,TCH,RCSD,EF,FC)
    
    w1=0.3;
    w2=0.4;
    w3=0.1;
    w4=0.2;
    z=w1*(TD-RCSD)+(1-w1)*(N-TCH)+ w3 * EF + w4 *FC;
    
end

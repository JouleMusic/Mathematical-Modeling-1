distense=zeros(130,130);
for i = 1:130
    fprintf('%g to (1-130)\n',i);
    for j = 1:130
        distense(i,j)=dijkstra(ddd,j,i);
        %fprintf(1,'%g\n',distense(i));
    end
end

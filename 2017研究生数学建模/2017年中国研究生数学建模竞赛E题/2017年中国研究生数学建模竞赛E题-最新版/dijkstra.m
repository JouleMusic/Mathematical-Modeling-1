function[L,Z]=dijkstra(W,S,T)
N=length(W(:,1));%顶点数
W(find(W==0))=inf;
L=Inf*ones(1,N);
L(S)=0;
C=S;
Q = 1:N;  % 未走访的顶点集
Z = S*ones(1,N);
Z(S)=0;
for K = 1:N  %更新L和Z的循环
    Q = setdiff(Q,C);
    [L(Q),ind] = min([L(Q),L(C)+W(C,Q)]);
    Z(Q(find(ind==2))) = C;
    if T&C == T
        L = L(T); % 最短路径长度
        road = T; % 最短路径终点
        while T~=S % 追溯最短路径上的点
            T=Z(T); % 从终点往前寻找其父亲结点
            road = [road,T];
        end
        Z=road(length(road):-1:1); % 颠倒次序
        return;
    end
    [null,mC]=min(L(Q));
    if null == Inf
        % disp(' 到值是 Inf 的点的路不通！ ');
        Z(find(L==Inf))==nan;
        return;
    else
        C=Q(mC);
        C;
    end
end
end

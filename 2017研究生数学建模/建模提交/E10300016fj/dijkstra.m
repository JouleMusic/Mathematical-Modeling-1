function[L,Z]=dijkstra(W,S,T)
N=length(W(:,1));%������
W(find(W==0))=inf;
L=Inf*ones(1,N);
L(S)=0;
C=S;
Q = 1:N;  % δ�߷õĶ��㼯
Z = S*ones(1,N);
Z(S)=0;
for K = 1:N  %����L��Z��ѭ��
    Q = setdiff(Q,C);
    [L(Q),ind] = min([L(Q),L(C)+W(C,Q)]);
    Z(Q(find(ind==2))) = C;
    if T&C == T
        L = L(T); % ���·������
        road = T; % ���·���յ�
        while T~=S % ׷�����·���ϵĵ�
            T=Z(T); % ���յ���ǰѰ���丸�׽��
            road = [road,T];
        end
        Z=road(length(road):-1:1); % �ߵ�����
        return;
    end
    [null,mC]=min(L(Q));
    if null == Inf
        % disp(' ��ֵ�� Inf �ĵ��·��ͨ�� ');
        Z(find(L==Inf))==nan;
        return;
    else
        C=Q(mC);
        C;
    end
end
end

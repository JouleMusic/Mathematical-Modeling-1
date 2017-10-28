clear all
close all
disp('The only input needed is a distance matrix file')
disp('The format of this file should be: ')
disp('Column 1: id of element i')
disp('Column 2: id of element j')
disp('Column 3: dist(i,j)')

%% ���ļ��ж�ȡ����
mdist=input('name of the distance matrix file (with single quotes)?\n');
disp('Reading input distance matrix')
xx=load(mdist);
ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
  ND=NL;  %% ȷ�� DN ȡΪ��һ�������ֵ�еĽϴ��ߣ���������Ϊ���ݵ�����
end

N=size(xx,1); %% xx ��һ��ά�ȵĳ��ȣ��൱���ļ�����������������ܸ�����

%% ��ʼ��Ϊ��
for i=1:ND
  for j=1:ND
    dist(i,j)=0;
  end
end

%% ���� xx Ϊ dist ���鸳ֵ��ע������ֻ���� 0.5*DN(DN-1) ��ֵ�����ｫ�䲹����������
%% ���ﲻ���ǶԽ���Ԫ��
for i=1:N
  ii=xx(i,1);
  jj=xx(i,2);
  dist(ii,jj)=xx(i,3);
  dist(jj,ii)=xx(i,3);
end

%% ȷ�� dc

percent=2.0;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(N*percent/100); %% round ��һ���������뺯��
sda=sort(xx(:,3)); %% �����о���ֵ����������
dc=sda(position);

%% ����ֲ��ܶ� rho (���� Gaussian ��)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��
for i=1:ND
  rho(i)=0.;
end

% Gaussian kernel
for i=1:ND-1
  for j=i+1:ND
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end

% "Cut off" kernel
%for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
%end

%% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ
maxd=max(max(dist)); 

%% �� rho ���������У�ordrho ������
[rho_sorted,ordrho]=sort(rho,'descend');
 
%% ���� rho ֵ�������ݵ�
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% ���� delta �� nneigh ����
for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj); 
        %% ��¼ rho ֵ��������ݵ����� ordrho(ii) ��������ĵ�ı�� ordrho(jj)
     end
   end
end

%% ���� rho ֵ������ݵ�� delta ֵ
delta(ordrho(1))=max(delta(:));

%% ����ͼ

disp('Generated file:DECISION GRAPH') 
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:ND
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

%% ѡ��һ��Χס�����ĵľ���
disp('Select a rectangle enclosing cluster centers')

%% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0
%% >> scrsz = get(0,'ScreenSize')
%% scrsz =
%%            1           1        1280         800
%% 1280 �� 800 ���������õļ�����ķֱ��ʣ�scrsz(4) ���� 800��scrsz(3) ���� 1280
scrsz = get(0,'ScreenSize');

%% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);

%% ind �� gamma �ں��沢û���õ�
for i=1:ND
  ind(i)=i; 
  gamma(i)=rho(i)*delta(i);
end

%% ���� rho �� delta ����һ����ν�ġ�����ͼ��

subplot(2,1,1)
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')

subplot(2,1,1)
rect = getrect(1); 
%% getrect ��ͼ��������ȡһ���������� rect �д�ŵ���
%% �������½ǵ����� (x,y) �Լ����ؾ��εĿ�Ⱥ͸߶�
rhomin=rect(1);
deltamin=rect(2); %% ���߳������Ǹ� error������ 4 ��Ϊ 2 ��!

%% ��ʼ�� cluster ����
NCLUST=0;

%% cl Ϊ������־���飬cl(i)=j ��ʾ�� i �����ݵ�����ڵ� j �� cluster
%% ��ͳһ�� cl ��ʼ��Ϊ -1
for i=1:ND
  cl(i)=-1;
end

%% �ھ���������ͳ�����ݵ㣨���������ģ��ĸ���
for i=1:ND
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     NCLUST=NCLUST+1;
     cl(i)=NCLUST; %% �� i �����ݵ����ڵ� NCLUST �� cluster
     icl(NCLUST)=i;%% ��ӳ��,�� NCLUST �� cluster ������Ϊ�� i �����ݵ�
  end
end

fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);

disp('Performing assignation')

%% ���������ݵ���� (assignation)
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end
%% �����ǰ��� rho ֵ�Ӵ�С��˳�����,ѭ��������, cl Ӧ�ö��������ֵ��. 

%% ������ε㣬halo��δ���Ӧ���Ƶ� if (NCLUST>1) ��ȥ�ȽϺð�
for i=1:ND
  halo(i)=cl(i);
end

if (NCLUST>1)

  % ��ʼ������ bord_rho Ϊ 0,ÿ�� cluster ����һ�� bord_rho ֵ
  for i=1:NCLUST
    bord_rho(i)=0.;
  end

  % ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho
  for i=1:ND-1
    for j=i+1:ND
      %% �����㹻С��������ͬһ�� cluster �� i �� j
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
        rho_aver=(rho(i)+rho(j))/2.; %% ȡ i,j �����ƽ���ֲ��ܶ�
        if (rho_aver>bord_rho(cl(i))) 
          bord_rho(cl(i))=rho_aver;
        end
        if (rho_aver>bord_rho(cl(j))) 
          bord_rho(cl(j))=rho_aver;
        end
      end
    end
  end

  %% halo ֵΪ 0 ��ʾΪ outlier
  for i=1:ND
    if (rho(i)<bord_rho(cl(i)))
      halo(i)=0;
    end
  end

end

%% ��һ����ÿ�� cluster
for i=1:NCLUST
  nc=0; %% �����ۼƵ�ǰ cluster �����ݵ�ĸ���
  nh=0; %% �����ۼƵ�ǰ cluster �к������ݵ�ĸ���
  for j=1:ND
    if (cl(j)==i) 
      nc=nc+1;
    end
    if (halo(j)==i) 
      nh=nh+1;
    end
  end

  fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);

end

cmap=colormap;
for i=1:NCLUST
   ic=int8((i*64.)/(NCLUST*1.));
   subplot(2,1,1)
   hold on
   plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
subplot(2,1,2)
disp('Performing 2D nonclassical multidimensional scaling')
Y1 = mdscale(dist, 2, 'criterion','metricstress');
plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
xlabel ('X')
ylabel ('Y')
for i=1:ND
 A(i,1)=0.;
 A(i,2)=0.;
end
for i=1:NCLUST
  nn=0;
  ic=int8((i*64.)/(NCLUST*1.));
  for j=1:ND
    if (halo(j)==i)
      nn=nn+1;
      A(nn,1)=Y1(j,1);
      A(nn,2)=Y1(j,2);
    end
  end
  hold on
  plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end

%for i=1:ND
%   if (halo(i)>0)
%      ic=int8((halo(i)*64.)/(NCLUST*1.));
%      hold on
%      plot(Y1(i,1),Y1(i,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%   end
%end
faa = fopen('CLUSTER_ASSIGNATION', 'w');
disp('Generated file:CLUSTER_ASSIGNATION')
disp('column 1:element id')
disp('column 2:cluster assignation without halo control')
disp('column 3:cluster assignation with halo control')
for i=1:ND
   fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
end
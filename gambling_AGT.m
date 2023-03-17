%% 世界杯彩票投注算法：阿根廷
clc
 clear all

%比分+半场胜负混买。
%确定策略空间x,y
%实际比赛结果R
%x_get收益矩阵


x_get_win=[4.5 5.1 6.75 5 9    ]

x_get_mnoey=[x_get_win]

%result为结果矩阵 
v=ones(1,5)
result=diag(v, 0)


%% 购买模型一  % 目标函与决策变量的定义

% x=intvar(1,31)
% % 限制条件一： 每一个结果都保证有收益。
% Constraints=[]
% for i=1:1:31
% 
% Constraints = [Constraints,sum(x.*x_get_mnoey.*result(i,:))-sum(x)>-1];
% 
% end
% 
% 
% % 限制条件二：每一个变量在1-50之间
% for i=1:1:31
%    
% Constraints = [Constraints,0<=x(i)<=50];
% 
% end
% 
% 
% %% 目标函数
% 
% f= -(sum(x));
% 
% %% 求解
% options=sdpsettings('solver','cplex'); 
% sol=optimize(Constraints,f,options); 
% 
% if sol.problem == 0 % problem =0 代表求解成功
%    solution = value(x)
%    res=value(f)
% else
%     disp('求解出错');
% end


%% 购买模型二
%比分+总进球个数
%n_ball 进球个数矩阵
n_ball_win=[2 3 4 5 6]


n_ball=[n_ball_win ]
ball_win_score=[4 3.9 4.75 6.5 10.5 ]

n_ball_win_score=[4 3.9 4.75 6.5 10.5 ]

n_ball_score=[n_ball_win_score ]

x=intvar(1,5)
y=intvar(1,5)
%site=zeros(1,8)
% site(1,size(sum(n_ball.*result(i,:)),2))=1
% 利润  y.*ball_win_score.*site-sum(y)

%限制条件一
%  Constraints=[]
% 
% for i=1:1:31
% 
% 
% site=zeros(1,8)  
% site(1,sum(n_ball.*result(i,:))+1)=1
% 
% 
% Constraints = [Constraints,sum(x.*x_get_mnoey.*result(i,:))+sum(y.*ball_win_score.*site)-sum(y)-sum(x)>0];
% 
% end
% 
% %限制条件二
% 
% for i=1:1:31
%    
% Constraints = [Constraints,0<=x(i)<=50];
% 
% end
% 
% 
% %限制条件三
% 
% 
% for i=1:1:8
%    
% Constraints = [Constraints,0<=y(i)<=50];
% 
% end
% 
% % 目标函数
% f=- (sum(x));
% 
% % 求解
% options=sdpsettings('solver','cplex'); 
% sol=optimize(Constraints,f,options); 
% 
% if sol.problem == 0 % problem =0 代表求解成功
%    solution_x = value(x)
%    solution_y = value(y)
%    res=value(f)
% else
%     disp('求解出错');
% end
% 
% figure
% bar(solution_x)
% 
% figure
% bar(solution_y)



%% 购买模型三  加本场胜率

z=intvar(1,2)
z_get=[1.9 3.9 ]  %胜负收益矩阵

%限制条件一
%比分与胜负平的关系：
  Constraints=[]
for i=1:1:5
% Step1 找出位置为1的关系式子。
m = find(result(i,:)==1)

% Step2 做判断，在胜负平的情况下
set_z=zeros(1,2)

if  0<m<=1
set_z(1,2)=1
end

if  1<m<=5
set_z(1,1)=1
end

% if  18<m<=31
% set_z(1,3)=1
% end

site=zeros(1,5)  
site(1,sum(n_ball.*result(i,:))-1)=1


Constraints = [Constraints,sum(x.*x_get_mnoey.*result(i,:))+sum(z.*z_get.*set_z)+sum(y.*ball_win_score.*site)
    -sum(y)-sum(x)-sum(z)>-10];

end

%限制二
for i=1:1:5
   
Constraints = [Constraints,0<=x(i)<=50];

end


%限制条件三


for i=1:1:5
   
Constraints = [Constraints,0<=y(i)<=50];

end
% 限制四
for i=1:1:2
   
Constraints = [Constraints,0<=z(i)<=50];

end

% 目标函数
f=-(sum(x));

% 求解
options=sdpsettings('solver','cplex'); 
sol=optimize(Constraints,f,options); 

if sol.problem == 0 % problem =0 代表求解成功
   solution_x = value(x)
   solution_y = value(y)
    solution_z = value(z)
   res=value(f)
else
    disp('求解出错');
end

figure
bar(solution_x)

figure
bar(solution_y)
figure
bar(solution_z)


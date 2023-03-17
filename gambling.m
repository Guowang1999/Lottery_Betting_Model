%% 世界杯彩票投注算法：
clc
 clear all

%比分+半场胜负混买。
%确定策略空间x,y
%实际比赛结果R
%x_get收益矩阵



x_get_win=[4.6 5.2 7.25  8.0 12.5 35 17  29  80   40  70 200  50   ]
x_get_equal=[8.5 6.9 23 150 800]
x_get_lose=[13 40 21 150 80 80 600 400 400 1000 1000 1000 500    ]
x_get_mnoey=[x_get_win x_get_equal x_get_lose]

%result为结果矩阵 
v=ones(1,31)
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
n_ball_win=[1 2 3 3  4 5 4 5 6 5 6 7 7]
n_ball_equal=[0 2 4 6 7]
n_ball_lose=[1 2 3 3 4 5 4 5 6 5 6 7 7 ]

n_ball=[n_ball_win n_ball_equal n_ball_lose]
ball_win_score=[8.25 4 3.2 3.65 6.65 12.5 24 40 ]

n_ball_win_score=[4 3.2 3.65 3.65 6.65 12.5 6.65 12.5 24 12.5 24 40 40 ]
n_ball_equa_score=[8.25 3.25 6.65 24 40 ]
n_ball_lose_score=[4 3.2 3.65 3.65 6.65 12.5 6.65 12.5 24 12.5 24 40 40 ]
n_ball_score=[n_ball_win_score n_ball_equa_score n_ball_lose_score]

x=intvar(1,31)
y=intvar(1,8)
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

z=intvar(1,3)
z_get=[1.34 3.78 7.8]  %胜负收益矩阵

%限制条件一
%比分与胜负平的关系：
  Constraints=[]
for i=1:1:31
% Step1 找出位置为1的关系式子。
m = find(result(i,:)==1)

% Step2 做判断，在胜负平的情况下
set_z=zeros(1,3)

if  0<m<=13
set_z(1,1)=1
end

if  13<m<=18
set_z(1,2)=1
end

if  18<m<=31
set_z(1,3)=1
end

site=zeros(1,8)  
site(1,sum(n_ball.*result(i,:))+1)=1


Constraints = [Constraints,sum(x.*x_get_mnoey.*result(i,:))+sum(y.*ball_win_score.*site)+sum(z.*z_get.*set_z)
    -sum(y)-sum(x)-sum(z)>0];

end

%限制二
for i=1:1:31
   
Constraints = [Constraints,0<=x(i)<=50];

end


%限制条件三


for i=1:1:8
   
Constraints = [Constraints,0<=y(i)<=50];

end
% 限制四
for i=1:1:3
   
Constraints = [Constraints,0<=z(i)<=50];

end

% 目标函数
f=- (sum(x));

% 求解
options=sdpsettings('solver','cplex'); 
sol=optimize(Constraints,f,options); 

if sol.problem == 0 % problem =0 代表求解成功
   solution_x = value(x)
   solution_y = value(y)
   res=value(f)
else
    disp('求解出错');
end

figure
bar(solution_x)

figure
bar(solution_y)





%% 电力分配计算






















% ca=90.87
% cb=165.33
% cc=256,74
% cd=223.18
% 
% ra=380
% rb=701
% rc=1120
% rd=991
% 
% re_total=ra+rb+rc+rd
% total=3000
% re_que=re_total-total
% 
% ra_1=ra-1/ca/(1/cb+1/cc+1/cd+1/ca)*re_que
% rb_1=rb-1/cb/(1/ca+1/cc+1/cd+1/cb)*re_que
% rc_1=rc-1/cc/(1/cb+1/ca+1/cd+1/cc)*re_que
% rd_1=rd-1/cd/(1/cb+1/cc+1/ca+1/cd)*re_que







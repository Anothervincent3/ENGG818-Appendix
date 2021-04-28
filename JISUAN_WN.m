%%
z=xlsread('G:\OneDrive\nan\多区域表21sectors.xlsx',1,'D4: XI633');
X=xlsread('G:\OneDrive\nan\多区域表21sectors.xlsx',1,'ADH4: ADH633');
f=xlsread('G:\OneDrive\nan\多区域表21sectors.xlsx',2,'CV3: DY632');
bw=xlsread('G:\OneDrive\nan\bluewater.xlsx',2,'AX37: BR66');
gw=xlsread('G:\OneDrive\nan\greywater.xlsx',3,'A1: U30');

%%
pbw=[];
pgw=[];
for i=1:30
   pbw=[pbw,funslr(bw,i,1,21)]; 
   pgw=[pgw,funslr(gw,i,1,21)];
end

%%
m=size(z,1);
I=eye(m);
x1=X';          
I1=ones(m,1);
I2=ones(1,m);
X1=I1*x1;
X2=X*I2;
a=z./X1;
a(a==inf)=0;
a(isnan(a)==1)=0;
a(a<1e-14)=0;
L=inv(I-a);
eb=pbw./x1;
eb(isnan(eb)==1)=0;
eg=pgw./x1;
eg(isnan(eg)==1)=0;
%%
ze=[];
for i=1:30
    T=funslc(z,i,21,m);
    Ts=sum(T,2);
    ze=[ze,Ts];
end
er=ze+f;
ER={};
A={};
EB={};
EG={};
for i=1:30
    for j=1:30
        a1=funslr(a,i,21,m);
        a2=funslc(a1,j,21,21);
        A(i,j)={a2};
        er1=funslr(er,i,21,30);
        er2=funslc(er1,j,1,21);
        ER(i,j)={er2};
        EB(i)={funslc(eb,i,21,1)};
        EG(i)={funslc(eg,i,21,1)};
    end
end

VWEb=zeros(30,30);
VWEg=zeros(30,30);
II=eye(21);
for i=1:30
    for j=1:30
        if i~=j
            VWEb(i,j)=[EB{i}]*(II-[A{i,i}])^(-1)*[ER{i,j}];
            VWEg(i,j)=[EG{i}]*(II-[A{i,i}])^(-1)*[ER{i,j}];
        elseif i==j
            VWEb(i,j)=0;
            VWEg(i,j)=0;
        end
    end
end
VWIb=zeros(30,30);
VWIg=zeros(30,30);
for i=1:30
    for j=1:30
        if i~=j
            VWIb(j,i)=[EB{j}]*(II-[A{j,j}])^(-1)*[ER{j,i}];
            VWIg(j,i)=[EG{j}]*(II-[A{j,j}])^(-1)*[ER{j,i}];
        elseif i==j
            VWIb(j,i)=[EB{j}]*(II-[A{j,j}])^(-1)*f(1+(j-1)*21:21+(j-1)*21,j);
            VWIg(j,i)=[EG{j}]*(II-[A{j,j}])^(-1)*f(1+(j-1)*21:21+(j-1)*21,j);
        end
    end
end




            

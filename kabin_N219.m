clear all;
close all;
clc;
tic;

%Parameter
Tling=19;
t=0.17; %tebal dari partisi (m)
k=25.87 ; %konstanta konduktivitas termal udara (mW/mK)
qgen =6253.2; %nilai pembangkitan kalor(W/m^2)
Lx=6.600; %Panjang kabin (m)
Ly=1.800; %Lebar kabin (m)
m=101; %Jumlah titik horizontal skala 1
n=101; %Jumlah titik vertikal skala 1

c=1; %Skala
M=(m*c)-(c-1); %Jumlah titik horizontal yang diproses
N=(n*c)-(c-1); %Jumlah titik vertikal yang diproses
D=M*N; %Jumlah total seluruh titik pada matriks A
dx=Lx/(M-1); %Panjang partisi
dy=Ly/(N-1); %Lebar partisi
TG=-qgen*dx*dy/k; %Kontribusi heat generation terhadap suhu

%Pembentukan Matriks A
A=zeros(D,D); %Matriks koefisien temperatur
C=zeros(D,1); %Matriks konstanta
i=0; %Counter

for a=1:N %Iterasi baris
	for b=1:M %Iterasi kolom
		i=i+1; %Menambahkan counter
		%Mengisi A & C
		%Pojok atas kiri
        if (a==1 && b==1)
            A(i,i)= -4;
            %A(i,i+1)=2;
            %A(i,i+M)=2;
            C(i)=-Tling*4;
        %Pojok atas kanan
        elseif (a==1 && b==M)
            A(i,i)= -4;
            %A(i,i-1)=2;
            %A(i,i+M)=2;
            C(i)=-Tling*4;
        %Pojok bawah kiri
        elseif (a==N && b==1)
            A(i,i)= -4;
            %A(i,i+1)=2;
            %A(i,i-M)=2;
            C(i)=-Tling*4;
        %Pojok bawah kanan
        elseif (a==N && b==M)
            A(i,i)= -4;
            %A(i,i-1)=2;
            %A(i,i-M)=2;
            C(i)=-Tling*4;
        %Insulasi tepi atas
        elseif (a==1 && (1<b && b<M))
            A(i,i)= -4;
            A(i,i-1)=1;
            A(i,i+1)=1;
            A(i,i+M)=2;
            %C(i)=-Tling*4;
        %Insulasi tepi kiri
        elseif ((1<a && a<N) && b==1)
            A(i,i-M)=1;
            A(i,i+1)=2;
            A(i,i)= -4;
            A(i,i+M)=1;
            %C(i)=-Tling*4;
        %Insulasi tepi kanan
        elseif ((1<a && a<N) && b==M)
            A(i,i-1)=2;
            A(i,i)= -4;
            A(i,i-M)=1;
            A(i,i+M)=1;
            %C(i)=-Tling*4;
        %Insulasi tepi bawah
        elseif (a==N && (1<b && b<M))
            A(i,i-1)=1;
            A(i,i)= -4;
            A(i,i+1)=1;
            A(i,i-M)=2;
            %C(i)=-Tling*4;
        %Bagian tengah
        elseif (a~=1 || a~=N || b~=1 || b~=M)
            A(i,i-M)=1;
            A(i,i-1)=1;
            A(i,i)= -4;
            A(i,i+1)=1;
            A(i,i+M)=1;
        end
        %Mengisi matriks C akibat heat generation
        %bagian atas	
        	%atas kiri
        if ((a==1 && b==14)||(a==1 && b==26)||(a==1 && b==38)||(a==1 && b==50)||(a==1 && b==62)||(a==1 && b==74)||(a==1 && b==86))
            C(i)=TG/4;
            %atas kanan
        elseif ((a==1 && b==15)||(a==1 && b==27)||(a==1 && b==39)||(a==1 && b==51)||(a==1 && b==63)||(a==1 && b==75)||(a==1 && b==87))
            C(i)=TG/4;
            %bawah kiri
        elseif ((a==2 && b==14)||(a==2 && b==26)||(a==2 && b==38)||(a==2 && b==50)||(a==2 && b==62)||(a==2 && b==74)||(a==2 && b==86))
            C(i)=TG/4;
            %bawah kanan
        elseif ((a==2 && b==15)||(a==2 && b==27)||(a==2 && b==39)||(a==2 && b==51)||(a==2 && b==63)||(a==2 && b==75)||(a==2 && b==87))
            C(i)=TG/4;
        %bagian bawah	
        	%atas kiri
        elseif ((a==100 && b==26)||(a==100 && b==38)||(a==100 && b==50)||(a==100 && b==62)||(a==100 && b==74))
            C(i)=TG/4;
            %atas kanan
        elseif ((a==100 && b==27)||(a==100 && b==39)||(a==100 && b==51)||(a==100 && b==63)||(a==100 && b==75))
            C(i)=TG/4;
            %bawah kiri
        elseif ((a==101 && b==26)||(a==101 && b==38)||(a==101 && b==50)||(a==101 && b==62)||(a==101 && b==74))
            C(i)=TG/4;
            %bawah kanan
        elseif ((a==101 && b==27)||(a==101 && b==39)||(a==101 && b==51)||(a==101 && b==63)||(a==101 && b==75))
            C(i)=TG/4;    
        end
    end
end

T=inv(A)*C; %Matriks temperatur secara vertikal

%Pemetaan Distribusi Temperatur
v=0; %Dummy variable
for a=1:N
    for b=1:M
        bv=b+v;
        L(a,b)=T(bv,1); %Matriks distribusi temperatur
    end
    v=v+M;
end

%Plot Kontur Temperatur
X=0:dx:Lx;
Y=0:dy:Ly;
[X,Y]=meshgrid(X,Y);
surf(X,Y,L);
view(2);

%set(gca,'xaxislocation','bottom');
colorbar;
title(['Distribusi Temperatur Kondisi Tunak dengan 25% Daya Heater']);
xlabel('Panjang Kabin (m)');
ylabel('Lebar Kabin (m)');

disp('Jumlah pemakaian memory:');
memory
disp('Durasi proses:');
toc

disp('Nilai temperatur di penumpang 1 adalah:')
disp(L(15,14));
disp('Nilai temperatur di penumpang 2 adalah:')
disp(L(40,14));
disp('Nilai temperatur di penumpang 3 adalah:')
disp(L(15,26));
disp('Nilai temperatur di penumpang 4 adalah:')
disp(L(40,26));
disp('Nilai temperatur di penumpang 5 adalah:')
disp(L(85,26));
disp('Nilai temperatur di penumpang 6 adalah:')
disp(L(15,38));
disp('Nilai temperatur di penumpang 7 adalah:')
disp(L(40,38));
disp('Nilai temperatur di penumpang 8 adalah:')
disp(L(85,38));
disp('Nilai temperatur di penumpang 9 adalah:')
disp(L(15,50));
disp('Nilai temperatur di penumpang 10 adalah:')
disp(L(40,50));
disp('Nilai temperatur di penumpang 11 adalah:')
disp(L(85,50));
disp('Nilai temperatur di penumpang 12 adalah:')
disp(L(15,62));
disp('Nilai temperatur di penumpang 13 adalah:')
disp(L(40,62));
disp('Nilai temperatur di penumpang 14 adalah:')
disp(L(85,62));
disp('Nilai temperatur di penumpang 15 adalah:')
disp(L(15,74));
disp('Nilai temperatur di penumpang 16 adalah:')
disp(L(40,74));
disp('Nilai temperatur di penumpang 17 adalah:')
disp(L(85,86));
disp('Nilai temperatur di penumpang 18 adalah:')
disp(L(15,86));
disp('Nilai temperatur di penumpang 19 adalah:')
disp(L(40,86));

%[DX,DY] = gradient(L,dx,Lx);
%figure(2), quiver(X,Y,DX,DY)
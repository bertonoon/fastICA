clear; clc;
format compact
format long
% Czytanie z pliku audio

[y1,Fs1] = audioread('kocie_ruchy.wav');
[y2,Fs2] = audioread('mialbym_ochote.wav');
[y3,Fs3] = audioread('silnoreki.wav');

% Czytanie infomracji o pliku audio 

info1 = audioinfo('mial_ogromne_szczescie.wav');
info2 = audioinfo('mialbym_ochote.wav');
info3 = audioinfo('silnoreki.wav');

% Tworzenie wektora czasu 

t1 = 0:seconds(1/Fs1):seconds(info1.Duration);
t1 = t1(1:end);
t2 = 0:seconds(1/Fs2):seconds(info2.Duration);
t2 = t2(1:end-1);
t3 = 0:seconds(1/Fs3):seconds(info3.Duration);
t3 = t3(1:end);

% sound(y1,Fs1)

% figure(1)
% subplot(2,2,1);
% plot(t1,y1);
% subplot(2,2,2);
% plot(t2,y2);
% subplot(2,2,3);
% plot(t3,y3);

% Wyrównywanie sygna³ów, tak ¿eby trwa³y tyle samo czasu
koniec = 243653;

t1 = t1(1:1:koniec);
t2 = t2(1:1:koniec);
t3 = t3(1:1:koniec);

y1 = y1(1:1:koniec);
y2 = y2(1:1:koniec);
y3 = y3(1:1:koniec);

% Mieszanina dwóch sygna³ów 
% S - wspolczynniki mieszania 
YM1 = 0.4*y1 + 0.9*y2 + 0.5*y3;
YM2 = 0.7*y1 + 0.2*y2 + 0.4*y3;
YM3 = 0.2*y1 + 0.5*y2 + 0.8*y3;

% figure(2)
% subplot(2,1,1);
% plot(t1,Y1);
% subplot(2,1,2);
% plot(t1,Y2);
% 
% figure(3)
% plot(Y1,Y2,'.');

sound(YM1,Fs1);
pause
sound(YM2,Fs1);
pause
sound(YM3,Fs1);
pause

% Centrowanie
N = 3; % Iloœæ mieszanin
M = koniec;
X = [YM1'; YM2'; YM3'];

% Y = WX w przyblizeniu = S

mx  = mean(X') ;
for i=1:N
        X(i,:) = X(i,:) - (1/M)*sum(X(i,:));
end

c   = cov(X');		 % covariance
sq  = inv(sqrtm(c));        % inverse of square root
mx  = mean(X');             % mean
XX  = X-mx'*ones(1,koniec); % subtract the mean
XX  = 2*sq*XX;              
cov(XX');                 % the covariance is now a diagonal matrix
% figure(5); 

% Inicjalizacja
a = rand(1);
w0 = [rand(1), rand(1), rand(1)];
w0 = w0/norm(w0);
w0 = w0';
% norm(w0)
B = zeros(3);

% Iteracja
XX = XX';
eps = 1e-6;
wi_1 = w0;
Z = [XX(:,1) XX(:,2) XX(:,3)]';
wi = zeros(size(wi_1));
k = 1;
while 1
    pom = [0;0;0];
    wi = Z*((wi_1'*Z)'.^3);
    for i=1:1:3
        for j=1:1:koniec
            pom(i)=pom(i)+wi(i);
        end
    end
    wi = pom;
    wi = wi./koniec;
    wi = wi-3*wi_1;
    
    if(k>1)
        wi = wi - B*B'*wi;
    end
    wi = wi/norm(wi);
%     display(wi)
    
    if ((wi'*wi_1)>1-eps) &&  ((wi'*wi_1)<1+eps);
        B(:,k) = wi;
        k = k+1;
        display(k)
    end
        if ((wi'*wi_1)>1-eps) &&  ((wi'*wi_1)<1+eps) && k==4;
        break;
        end

    wi_1 = wi;
end

% vi = [ -wi(2); wi(1)];

czyste = B'*Z;
czyste = czyste/norm(czyste);
czyste = czyste.*107.5;

czyste1 = czyste(1,:);
czyste2 = czyste(2,:);
czyste3 = czyste(3,:);


% figure(6) 
% subplot(2,1,1)
% plot(t1,y1,'b-',t1,czyste1,'r-');
% axis([0 0.8 -5 5]);
% subplot(2,1,2)
% plot(t1,y2,'b-',t1,-czyste2,'r-');
% axis([0 0.8 -5 5]);
 sound(czyste1,Fs1)
 pause
 sound(czyste2,Fs1)
 pause 
sound(czyste3,Fs1)
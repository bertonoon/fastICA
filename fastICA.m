format compact
format long
% Czytanie z pliku audio

[y1,Fs1] = audioread('mial_ogromne_szczescie.wav');
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
Y1 = 0.4*y1 + 0.9*y2;
Y2 = 0.9*y1 + 0.2*y2;

% figure(2)
% subplot(2,1,1);
% plot(t1,Y1);
% subplot(2,1,2);
% plot(t1,Y2);
% 
% figure(3)
% plot(Y1,Y2,'.');

% sound(ym1,Fs1);
% pause
% sound(ym2,Fs1);

% Centrowanie
N = 2; % Iloœæ mieszanin
M = koniec;
X = [Y1'; Y2'];

% figure(4)
% subplot(2,1,1);
% plot(t1,X(1,:));
% subplot(2,1,2);
% plot(t2,X(2,:));
% hold on
mx  = mean(X') 
for i=1:N
        X(i,:) = X(i,:) - (1/M)*sum(X(i,:));
end

% figure(4)
% subplot(2,1,1);
% plot(t1,X(1,:));
% subplot(2,1,2);
% plot(t2,X(2,:));
% hold off

% Wybielanie
c   = cov(X')		 % covariance
sq  = inv(sqrtm(c));        % inverse of square root
mx  = mean(X')             % mean
XX  = X-mx'*ones(1,koniec); % subtract the mean
XX  = 2*sq*XX;              
cov(XX')                 % the covariance is now a diagonal matrix
% figure(5); 
% plot(XX(1,:), XX(2,:), '.');

% Inicjalizacja
a = rand(1);
w0 = [a,0];
w0(2) = sqrt(1 - (w0(1)^2));
w0 = w0';
norm(w0)

% Iteracja
eps = 1e-15;
wi_1 = w0;
Z = [XX(1,:)',XX(2,:)']';

while 1 
    wi = (1/koniec)*sum(Z*(wi_1'*Z)'.^3) - 3*wi_1;
    wi = wi/norm(wi);
    display(wi)

    if ((wi'*wi_1)>1-eps) &&  ((wi'*wi_1)<1+eps)
       break; 
    end
    wi_1 = wi;
end

czyste1 = wi'*Z;
% sound(czyste1,Fs1)
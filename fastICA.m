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
ym1 = 0.4*y1 + 0.9*y2;
ym2 = 0.9*y1 + 0.2*y2;

% sound(ym1,Fs1);
% sound(ym2,Fs1);


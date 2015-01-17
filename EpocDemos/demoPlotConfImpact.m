% it only loads other results and creates a plot illustrating the impact of using confidence
eeg_dir = '~/Desktop/eeg';

load(sprintf('%s/epocXp.adhoc.decim8ted.oct', eeg_dir));
r1 = results;

load(sprintf('%s/epocXp2nduser.decim8ted.oct', eeg_dir));
r2 = results;

figure;
hold on;
plot(r1.b1_cnfImpact(:,1), r1.b1_cnfImpact(:,2), 'r');
plot(r1.b2_cnfImpact(:,1), r1.b2_cnfImpact(:,2), 'g');
plot(r1.b3_cnfImpact(:,1), r1.b3_cnfImpact(:,2), 'b');
plot(r2.cnfImpact(:,1), r2.cnfImpact(:,2), 'm');
xlabel('Ryzyko');
ylabel('Srednia liczba powtorzen potrzebnych do podjecia decyzji');
legend('Dane A', 'Dane B', 'Dane C', 'Dane D');
hold off;

figure;
hold on;
plot(r1.b1_cnfImpact(:,1), r1.b1_cnfImpact(:,3), 'r');
plot(r1.b2_cnfImpact(:,1), r1.b2_cnfImpact(:,3), 'g');
plot(r1.b3_cnfImpact(:,1), r1.b3_cnfImpact(:,3), 'b');
plot(r2.cnfImpact(:,1), r2.cnfImpact(:,3), 'm');
xlabel('Ryzyko');
ylabel('Jakosc klasyfikacji');
axis([0,1,0.7,1.1]);
legend('Dane A', 'Dane B', 'Dane C', 'Dane D');
hold off;
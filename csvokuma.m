x=1000.*rand(50000,5);
csvwrite('randomdata.csv',x);
data=csvread('randomdata.csv');
disp(data)
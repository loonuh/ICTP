close all
clear all

MAX = load('max.txt');
omega = load('omega.txt');
DATA = load('data.txt');

figure
bar(MAX(2,:),MAX(1,:),'g');
axis([1 53 .5 1])

figure
pcolor(omega); shading interp 

figure
pcolor(data); shading interp 
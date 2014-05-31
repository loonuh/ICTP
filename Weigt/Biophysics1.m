close all
clear all
%------------------------------------------------------%
%      Weigst Statistical Biophysics Project @ ICTP    %
%                                                      %
% Code By: Riccardo Giuseppe Margiotta,                %
%          Agnese Curatolo, and Christopher Luna       %
%------------------------------------------------------%

%------------------------------------------------------%
%             Set Dataset Parameters                   %
%------------------------------------------------------%
D = 1000; %Number of Sequences in database
L = 53; %Length of Sequences 
q = 21; %Number of nucleotides in {A,C,...Y,-}

%------------------------------------------------------%
% Load Data, Preallocating Variables, Plots(On/Off) %                           %
%------------------------------------------------------%
DATA = load('data.txt');
n = zeros(L,q); %n(a)_i
nn = zeros(L,L,q,q); %n(a,b)_{i,j}
ww = zeros(L,L,q,q); %w(a,b)_{i,j}
M = zeros(L,L); %M_{i,j}
dists = load('distances.txt'); %Distances
squeezeM = zeros(4,L*L); %For building M
counter = 0;

plots = 1; %Plots (On/Off;1/0)
%------------------------------------------------------%
%   II. MODELING BY PSWM                               %
%------------------------------------------------------%
for i = 1:D
    for j = 1:L
        n(j,DATA(i,j)) = n(j,DATA(i,j)) + 1; 
    end
end

for i = 1:L
    for a=1:q
        omega(i,a) = (n(i,a)+1)/(1.0*(D+q));
    end
end

for i=1:L
    arrMax(i) = -inf;
    for a=1:q
        if(omega(i,a)>arrMax(i))
            arrMax(i)=omega(i,a);
        end
    end
end

%------------------------------------------------------%
%   III. CO-EVOLUTION OF CONTACT RESIDUES              %
%------------------------------------------------------%
for seqNumb = 1:D
    clc
    fprintf('Calculating n_ij: %5.2f %% \n',seqNumb/D*100)
    for j = 2:L
        for i = 1:j-1
            for a = 1:q
                for b = 1:q
                    if (DATA(seqNumb,i) == a) && (DATA(seqNumb,j) == b)
                        nn(i,j,a,b) = nn(i,j,a,b)+1;
                        
                    end
                end
            end
        end
    end
end

for j = 2:L
    clc
    fprintf('Calculating w_ij: %5.2f %% \n',(j-1)/(L-1)*100)
    for i = 1:j-1
        for a = 1:q
            for b = 1:q
                ww(i,j,a,b) = (nn(i,j,a,b) + 1/q)/(D+q);
            end
        end
    end
end

%------------------------------------------------------%
%                  Build M matrix                      %
%------------------------------------------------------%
for j = 2:L
    clc
    fprintf('Calculating M_ij: %5.2f %% \n',(j-1)/(L-1)*100)
    for i = 1:j-1
        for a = 1:q
            for b = 1:q
                M(i,j) = M(i,j) ...
                    + ww(i,j,a,b)*log(ww(i,j,a,b)/omega(i,a)/omega(j,b));
            end
        end
    end
end

%------------------------------------------------------%
%            Assign distances to pairs                 %
%------------------------------------------------------%
for j = 2:L
    for i = 1:j-1
        counter = counter+1;
        squeezeM(:,counter) = [M(i,j),i,j,0]';
    end
end

[sortM, index1] = sort(squeezeM(1,:),'descend');
index2 = find(sortM ~= 0);

sortM = squeezeM(:,index1(index2));

for i = 1:size(sortM,2)
    rowCoord = find(dists(:,1) == sortM(2,i));
    colCoord = find(dists(:,2) == sortM(3,i));
    extractVal =  intersect(rowCoord,colCoord);
    sortM(4,i) = dists(extractVal,end);
end

%------------------------------------------------------%
%Determine the fraction of pairs that have < 8 distance%
%------------------------------------------------------%
clc
i = 1;
while 2^(i-1) < size(sortM,2)  
        index4(i) = 2^(i-1);
        frac(i) = length(find(sortM(4,1:index4(i)) <= 8))/length(sortM(4,1:index4(i)));
        fprintf('Fraction of pair-distance < 8 for first %d pairs is: %f \n',index4(i),frac(i));
        i=i+1;
end

%------------------------------------------------------%
%                      Plots                           %
%------------------------------------------------------%
if plots
    subplot(1,3,1);bar(sortM(4,:))
    title('All distances for pairs')
    xlabel('Rank by M');
    ylabel('Distance');
    axis tight
    
    index3 = find(sortM(4,:) < 8);
    subplot(1,3,2);bar(index3,sortM(4,index3));
    title('Distances <= 8')
    xlabel('Rank by M');
    ylabel('Distance');
    axis([min(index3),max(index3),min(sortM(4,:)),max(sortM(4,:))])
    
    subplot(1,3,3);plot(index4,frac);axis tight
    title('Fraction of pair-distances < 8 vs. Number of pairs considered');
    ylabel('Fraction of pair-distances < 8');
    xlabel('Number of pairs considered');
end
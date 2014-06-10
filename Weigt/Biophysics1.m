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
%  Load Data, Preallocating Variables, Plots(On/Off)   %
%------------------------------------------------------%
%DATA = load('data.txt');
%DATA = load('t2matrix.txt');
%DATA = load('t1matrix.txt');
colorArr = {'blue','green','red'}
nameArr = {'data.txt','t1matrix.txt','t2matrix.txt'};
for nameInd = 1:length(nameArr)
    name = nameArr{nameInd};
    eval(['DATA = load(''',name,''');']);
    
    n= zeros(L,q); %n(a)_i
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
    
    index3(nameInd,:) = find(sortM(4,:) < 8);
    saveDists(nameInd,:) = sortM(4,:);
    
    while 2^(i-1) < size(sortM,2)
        index4(i) = 2^(i-1);
        index5(i) = i-1;
        frac(nameInd,i) = length(find(sortM(4,1:index4(i)) <= 8))/length(sortM(4,1:index4(i)));
        fprintf('Fraction of pair-distance < 8 for first %d pairs is: %f \n',index4(i),frac(i));
        i=i+1;
    end
    
end

%------------------------------------------------------%
%                      Plots                           %
%------------------------------------------------------%
%%
Ind = [1,3]
if plots
    subplot(2,1,1);
    for i = Ind
        eval(['plot(log2(1:1024),saveDists(i,1:1024),''',colorArr{i},''',''LineStyle'',''+'')']); 
        hold all
    end
    plot(0:10,ones(1,11)*8,'g-')
    title('All pair-distances vs. pair-rank')
    xlabel('Rank by M_{ij} score');
    ylabel('Distance (Angstroms)');
    legend('train.faa','test2.faa','Location','best');
    
    
    subplot(2,1,2);plot(index5,frac(1,:),'bo-'); hold on
    subplot(2,1,2);plot(index5,frac(2,:),'ro-');
    
    title('Fraction of true-positive predictions  vs. log_2(Number of best ranks considered)');
    ylabel('Fraction of pair-distances < 8');
    xlabel('log_2(Number of best ranks considered)');,
    legend('train.faa','test2.faa');
end

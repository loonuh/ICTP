close all
clear all

D = 1000;
L = 53;
q = 21;

plots = 0;
DATA = load('data.txt');
n = zeros(L,q);
nn = zeros(L,L,q,q);
ww = zeros(L,L,q,q);
M = zeros(L,L);

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
%%
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
M = M'+M
%%       

pcolor(M)
title('M matrix, is this supposed to by symmetric like this?')
colorbar
if plots
    figure
    bar(MAX(2,:),MAX(1,:),'g');
    axis([1 53 .5 1])
    
    figure
    pcolor(omega); shading interp
    
    figure
    pcolor(DATA); shading interp
end

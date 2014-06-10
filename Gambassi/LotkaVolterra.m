close all
clear all

maxIterations = 1000000;

L = 200;
p1 = .5;
p2 = .5;

video = 0;


if video
    vidObj = VideoWriter('Pred-Prey-Lattive.avi')
    vidObj.FrameRate = 10;
    open(vidObj);
end

arrDataOnes = ones(1,floor(L*L*p1));
arrDataTwos = 2*ones(1,floor(L*L*p2));
arrDataZeros = zeros(1,L*L - length(arrDataOnes)-length(arrDataTwos));

arrData = [arrDataTwos arrDataOnes arrDataZeros];

indx = randperm(length(arrData));
arrData = arrData(indx);
matData = reshape(arrData,[L,L]);

ocean = matData;
%ocean = [-1*ones(length(ocean),1),ocean,-1*ones(length(ocean),1)];
%ocean = [-1*ones(1,length(ocean));ocean;-1*ones(1,length(ocean))];


rates = [.1,1.6,50]; %mu,lambda,sigma
mu = rates(1);
lambda = rates(2);
sigma = rates(3);

W = [0      0       sigma   ;
     0      0       lambda  ;
     sigma  lambda  0       ];  

for iterations = 1:maxIterations
    iterations
    ocean = posCheck(ocean,W,mu);
    if mod(iterations,5000) == 0
        pcolor(ocean); shading flat; title('Lotka-Volterra Predator-Prey')
        colorbar();
        caxis([0 2])
        drawnow
        if video
            writeVideo(vidObj,getframe(gcf));
        end 
    end
end

if video
    close(vidObj);
end
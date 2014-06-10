function [oceanNext] = posCheck(ocean,W,mu)

%Non-periodic boundary
%pos = randi([2 (length(ocean)-2)],[1 2]);

%Periodic boundary
pos = randi([1 length(ocean)],[1 2]);
oceanNext = ocean;

species = ocean(pos(1),pos(2));
[neighbors,coords] = percross(ocean,pos(1),pos(2));

%    neighbors = [matrix(xcor,ycor_p) matrix(xcor_p,ycor) ...
%                   matrix(xcor,ycor_m) matrix(xcor_m,ycor)];

%Non-periodic boundary
%{
if min(neighbors) == -1
    index = find(neighbors == -1);
    species(index) = 0;
    neighbors(index) = 0;
end
%}

rates = W(species+1,neighbors+1);

if species == 1
    rates = [rates mu];
    probs = cumsum(rates./sum(rates));
else
    probs = cumsum(rates./sum(rates));
end

if any(isnan(probs))
    %Do nothing
else
    chi = rand(1);
    processIndex = find(probs > chi,1,'first');
    if processIndex == 5
        %Kill A at pos
        oceanNext(pos(1),pos(2)) = 0;
    else
        proXcor = coords(processIndex,1);
        proYcor = coords(processIndex,2);
        
        [upSpecies,upNeighbor] = LVreactions(species,ocean(proXcor,proYcor));
        oceanNext(pos(1),pos(2)) = upSpecies;
        oceanNext(proXcor,proYcor) = upNeighbor;
    end
end

end


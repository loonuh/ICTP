function [speciesBecomes,neighborBecomes] = LVreactions(species,neighbor)
speciesBecomes = species;
neighborBecomes = neighbor;

if (species == 1 && neighbor == 2)
    neighborBecomes = 1;
elseif(species == 2 && neighbor == 1)
    speciesBecomes = 1;
elseif (species == 2 && neighbor == 0)
    neighborBecomes = 2;
elseif(species == 0 && neighbor == 2)
    speciesBecomes = 2;
end

end


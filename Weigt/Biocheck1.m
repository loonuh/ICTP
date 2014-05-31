icheck = 1; %position
acheck = 1; %nucleotide
if exist('ww') == 0
    ww = load('ww.txt');
end

fprintf('omega(i,a) = %f \n',omega(icheck,acheck))
matCheck(:,:) = ww(icheck,:,acheck,:);
numCheck = unique(unique(nonzeros(sum(matCheck,2))));
fprintf('Sum over b''s for all j not equal 1 = %f \n',numCheck(1))
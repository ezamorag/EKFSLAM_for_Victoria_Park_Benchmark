function H = ICNN(observations, compatibility)
% Author: Erik Zamora, ezamora1981@gmail.com

for i=1:observations.m
    if ~isempty(find(compatibility.ICNN(i,:) == 1)) 
        [no_used H(i)]= min(compatibility.Mdist(i,:));
    else
        H(i) = 0;
    end
end
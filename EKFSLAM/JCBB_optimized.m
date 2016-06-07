function H = JCBB_optimized(estimates,observations,compatibility)
% Author: Erik Zamora, ezamora1981@gmail.com

global Best VISITEDNODES

Best = zeros(1, observations.m);
JCBB_R(estimates, observations ,compatibility, [], 1);
H = Best;

%disp(sprintf('Visited Nodes (default, JCBB.m) = %d', VISITEDNODES));


function JCBB_R(estimates,observations,compatibility, H, i)
global Best VISITEDNODES

VISITEDNODES = VISITEDNODES + 1;
if i > observations.m % leaf node?
    if pairings(H) > pairings(Best) % did better?
        Best = H;
    end
else
    if pairings(H) + pairings(compatibility.AL(i+1:end)) >= pairings(Best)
        individually_compatible = find(compatibility.ICNN(i,:));
        for j = individually_compatible
            if jointly_compatible(estimates,observations,compatibility,[H j])
                JCBB_R(estimates,observations,compatibility,[H j],i + 1); %pairing (Ei, Fj) accepted 
            end
        end
    end
    if pairings(H) + pairings(compatibility.AL(i+1:end)) >= pairings(Best) % can do better?
        JCBB_R(estimates,observations,compatibility,[H 0],i + 1); % star node: Ei not paired
    end
end





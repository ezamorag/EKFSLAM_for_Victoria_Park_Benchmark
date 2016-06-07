function [estimates new] = updateEKF(estimates,observations,compatibility,H)
% Author: Erik Zamora, ezamora1981@gmail.com

global noise
new = [];
for i=1:size(H,2) 
    j = H(i);
    if j > 0    
        % Update the estimates       
        dH = compatibility.dH(2*j-1:2*j,:);  
        K =  estimates.P*dH'/(dH* estimates.P*dH' + noise.Rz);
        innov = [observations.z(1,i)-compatibility.z(1,j); pi_pi(observations.z(2,i)-compatibility.z(2,j))];
        estimates.x = estimates.x + K*innov;
        estimates.P = (eye(3+2*estimates.n)-K*dH)* estimates.P;
        estimates.count(j) = estimates.count(j) + 1;
    else
        % only new features with no neighbours
        if compatibility.AL(i) == 0 
            new = [new i];
        end
    end
end






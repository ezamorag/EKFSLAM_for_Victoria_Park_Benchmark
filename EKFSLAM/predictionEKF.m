function estimates = predictionEKF(estimates,u,T)
% Author: Erik Zamora, ezamora1981@gmail.com

global noise vehicle
L = vehicle.L;
a = vehicle.a;
b = vehicle.b;

N = estimates.n;
vt = u(1);
at = u(2);
th = estimates.x(3);

Dfx = [1 0 -T*vt*(sin(th) + 1/L*tan(at)*(a*cos(th) - b*sin(th))); 
       0 1  T*vt*(cos(th) - 1/L*tan(at)*(a*sin(th) + b*cos(th)));
       0 0  1];
Gt = [Dfx, zeros(3,2*N); zeros(2*N,3) eye(2*N,2*N)];

% Es necesario tomar encuenta este ruido de este modo? R= No, es mas, es
% contraproducente, porque no pude hallar solución en VP así. 
tmp1 = a*sin(th) + b*cos(th);
tmp2 = a*cos(th) - b*sin(th);
Dfu = T*[cos(th) - 1/L*tan(at)*tmp1, -vt/L*sec(at)^2*tmp1;
         sin(th) + 1/L*tan(at)*tmp2,  vt/L*sec(at)^2*tmp2;
         1/L*tan(at),                 vt/L*sec(at)^2];
Vt = [Dfu ; zeros(2*N,2)];
Mt = [ noise.c(1:2)*[vt^2; at^2], 0;
       0, noise.c(3:4)*[vt^2; at^2]];

% Predict the belief
estimates.x = estimates.x + [T*vt*(cos(th) - 1/L*tan(at)*tmp1); 
                             T*vt*(sin(th) + 1/L*tan(at)*tmp2);
                             T*vt/L*tan(at); 
                             zeros(2*N,1)];
         
estimates.P = Gt*estimates.P*Gt' + blkdiag(noise.Qx,zeros(2*N)); %Vt*Mt*Vt';

function [ang]=pi_pi(x)
% Author: Erik Zamora, ezamora1981@gmail.com

ang = mod(x,2*pi);
index = find(ang > pi);
ang(index) = ang(index)-2*pi;

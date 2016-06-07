clc, clear all, close all
% Author: Erik Zamora, ezamora1981@gmail.com

addpath('EKFSLAM')
global vehicle noise map VISITEDNODES

% Configuration
vehicle.L = 2.83; %m
vehicle.a = 3.78; %m
vehicle.b = 0.5;  %m

noise.Qu = diag([15 1.5]);  % (velocity, steering)
noise.c = 3*[1 1 0.05 0.05];    % Modelo de Thrun

noise.Qx = diag([0.05 0.05 0.001]); % (x, y, th)  [0.05 0.05 0.001]
noise.Rz = diag([1 0.01]);   % (range, angle)     [1 0.01]


Tkz = 200;
map.Npruning = 50; % 30
map.distmin = 7;  % m  7
map.chi2 = chi2inv(1-0.95,2);  %  0.95
%load('chi_k.mat', 'chi_k');
map.chi_k = chi2inv(1-0.95,1:1000);  %chi_k; 
%clear chi_k

VISITEDNODES = 0;

% Victoria Park Dataset
load('VictoriaParkSinSincronizar.mat')

% Map initialization
x0 = [-67.6493; -41.7142; 35.5*pi/180]; %Initial condition
estimates.n = 0;
estimates.x = x0;
estimates.P = zeros(3,3);
estimates.count = [];

% Get observations
kz = 1;
observations.z = zt{kz};
observations.m = size(zt{kz},2);
xGTsimu(kz,:) = estimates.x(1:3)';
kz = kz + 1;

% Add features
estimates = add_features(estimates,observations);
ku_initial = 2;
%load('VP61900.mat')

xest{1} = x0;
tic
for ku=ku_initial:61945
    % get controls and sample time
    T = time(ku) - time(ku-1);
    
    % prediction
    estimates = predictionEKF(estimates,u(:,ku-1),T);
    
    if kz <= 7249
        xGTsimu(kz,:) = estimates.x(1:3)';
        if TLsr(kz) < time(ku)
            % get observations
            observations.z = zt{kz};
            observations.m = size(zt{kz},2);
            kz = kz + 1;


            if observations.m > 0 && estimates.n > 0
                % Data association
                compatibility = individual_compatibility(estimates,observations);
                H = ICNN(observations,compatibility);
                %H = JCBB(estimates,observations,compatibility);
                %H = JCBB_optimized(estimates,observations,compatibility);

                % Update
                [estimates new] = updateEKF(estimates,observations,compatibility,H);

                % Add new features 
                estimates = add_features(estimates,observations,new);
            elseif observations.m > 0 && estimates.n == 0
                estimates = add_features(estimates,observations);
            end
        end
    end

    
    if mod(kz,Tkz) == 0
        estimates = pruning(estimates);
    end
    xest{ku} = estimates.x;
    numlandmarks(ku) = estimates.n;
    if mod(kz,50) == 0 
        N = estimates.n
        kz
    end
    
    if mod(kz,250) == 0
        close all
        graphicsSLAM(xest,estimates.count)
        pause(0.1)
    end
end
toc
close all
graphicsSLAM(xest,estimates.count)
figure, plot(numlandmarks)
mean(numlandmarks)
discontinuaty(xest)

rmpath('EKFSLAM')

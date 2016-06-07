function graphicsSLAM(x,count)
% Author: Erik Zamora, ezamora1981@gmail.com

N = round((size(x{end},1) - 3)/2);

for i=1:length(x)
    xrobot(:,i) = x{i}(1:3);
end
plot(xrobot(1,:),xrobot(2,:),'k.','Markersize',5)
xlabel('Longitude (m)'), ylabel('Latitude (m)')

hold on
load aa3_gpsx ; 
hold on, plot(Lo_m,La_m,'.','Markersize',5);
legend('EKF-SLAM','GPS')

xmap = x{end};
for j=4:2:length(xmap)
    
    if count(round((j-3)/2)) < 30
        color = 'ro';
    elseif count(round((j-3)/2)) < 100
        color = 'ro';
    else 
        color = 'ro';
    end
    plot(xmap(j),xmap(j+1),color)
end

hold off
axis([-180 80 -110 200])
grid on

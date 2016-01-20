function DrawPlane3Points(pointA,pointB,pointC)
points=[pointA' pointB' pointC']; % using the data given in the question
fill3(points(1,:),points(2,:),points(3,:),'r')
grid on
alpha(0.3)

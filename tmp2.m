 clear
 load('points.mat')
 pc=Cloud(points);
 eval=Evaluator(1,1000);
 eval2=Evaluator(0.5,200);
 planes=pc.FindPlanes(eval);
 
 nonplane=find(planes==-1);
 np=Cloud(pc.Points(nonplane,:));
 lines=np.FindLines(eval2);
 new_detected=find(lines>0);
 lines(new_detected)=lines(new_detected)+max(planes);
 planes(nonplane(new_detected))=lines(new_detected);
 
figure
for i=1:max(planes)
    ind=find(planes==i);
    if mod(i,6)==1
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'r.');
    elseif mod(i,6)==2
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'g.');
    elseif mod(i,6)==3
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'b.');
    elseif mod(i,6)==4
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'c.');
    elseif mod(i,6)==5
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'m.');
    else
        plot3(pc.Points(ind,1),pc.Points(ind,2),pc.Points(ind,3),'y.');
    end
    hold on 
end
% for i=1:max(lines)
%     ind=find(lines==i);
%     if mod(i,6)==1
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'r.');
%     elseif mod(i,6)==2
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'g.');
%     elseif mod(i,6)==3
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'b.');
%     elseif mod(i,6)==4
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'c.');
%     elseif mod(i,6)==5
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'m.');
%     else
%         plot3(np.Points(ind,1),np.Points(ind,2),np.Points(ind,3),'y.');
%     end
%     hold on 
% end

%ind0=find(planes==-1);
%plot3(pc.Points(ind0,1),pc.Points(ind0,2),pc.Points(ind0,3),'k.');
grid on
axis equal
axis auto
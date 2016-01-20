classdef Cloud
    properties %(SetAccess=protected)
        Points;
        Length;
    end
    methods
        
        function obj=Cloud(points)
            if size(points,2)==3
                obj.Points=points;
                obj.Length=size(points,1);
            elseif size(points,1)==3
                obj.Points=points';
                obj.Length=size(points,2);
            end
        end
        
        function obj=Clone2Cloud(cp2,subs)
            obj=Cloud(cp2.SubCloud(subs));
        end
        
        function distances = Point2CloudDist(obj,pointA)
            if size(obj.Points,2)~=size(pointA,2);
                error('dimension dismatch');
            else
                ball=obj.Points-padarray(pointA,[obj.Length-1,0],'replicate','post');
                distances=sqrt(ball(:,1).^2+ball(:,2).^2+ball(:,3).^2);
            end
        end
        
        function SubCloudPoints = SubCloud(obj,subs)
            SubCloudPoints = obj.Points(subs,:);
        end
        
        function distances = Plane2CloudDist(obj,PlaneA)
            %distances are either positive or negative
            normal = PlaneA.getNorm();
            position = PlaneA.getPos();
            distances = (obj.Points - ...
                padarray(position,[obj.Length-1,0],'replicate','post'))...
                *normal';
        end
        
        function distances = Line2CloudDist(obj,LineA)
            lines = (obj.Points- ...
                padarray(LineA.End,[obj.Length-1,0],'replicate','post'));
            projection = lines*LineA.Direction';
            dist=lines-padarray(projection,[0,2],'replicate','post').*...
                padarray(LineA.Direction,[obj.Length-1,0],'replicate','post');
            distances = sqrt(sum(dist.^2,2));
        end
                
        function PlotCloud3(obj,prop)
            plot3(obj.Points(:,1),obj.Points(:,2),obj.Points(:,3),prop);
        end
        
        function index=FindOnePlane(obj,test)
            max_score=0;
            best=0;
            iteration=floor(obj.Length/30);
            P=cell(1,iteration);
            for i=1:iteration
                index=randi(obj.Length,1,3);
                base=obj.SubCloud(index);
                plane=Plane(base(1,:),base(2,:),base(3,:));
                score=test.ScorePlaneInCloud(obj,plane);
                P{i}=plane;
                if score>max_score
                    best=i;
                    max_score=score;
                end
            end
            dst=obj.Plane2CloudDist(P{best});
            ind=find(abs(dst)<=test.Margin);
            if length(ind)<test.MinPntNum
                index=[];
            else
                plane_cloud=Cloud(obj.Points(ind,:));
                connected=test.FindConnectedInCloud(plane_cloud);
                if isempty(connected)
                    index=[];
                else
                    best=0;
                    besti=0;
                    for i=1:length(connected)
                        if length(connected{i})>best
                            besti=i;
                        end
                    end
                    index=ind(connected{besti});
                end
            end
        end
        
        function index=FindOneLine(obj,test)
            max_score=0;
            best=0;
            iteration=floor(obj.Length/10);
            P=cell(1,iteration);
            for i=1:iteration
                index=randi(obj.Length,1,2);
                base=obj.SubCloud(index);
                line=Line(base(1,:),base(2,:));
                score=test.ScoreLineInCloud(obj,line);
                P{i}=line;
                if score>max_score
                    best=i;
                    max_score=score;
                end
            end
            dst=obj.Line2CloudDist(P{best});
            ind=find(abs(dst)<=test.Margin);
            if length(ind)<test.MinPntNum
                index=[];
            else
                line_cloud=Cloud(obj.Points(ind,:));
                connected=test.FindConnectedInCloud(line_cloud);
                if isempty(connected)
                    index=[];
                else
                    best=0;
                    besti=0;
                    for i=1:length(connected)
                        if length(connected{i})>best
                            besti=i;
                        end
                    end
                    index=ind(connected{besti});
                end
            end
        end
        
        function planes=FindPlanes(obj,eval)
            Markers=zeros(obj.Length,1);
            counter=0;
            while(length(find(Markers==0))>0)
                unmarked=find(Markers==0);
                pc=Cloud(obj.Points(unmarked,:));
                ind=pc.FindOnePlane(eval);
                if ~isempty(ind)
                    counter=counter+1;
                    Markers(unmarked(ind))=counter;
                else
                    Markers(unmarked)=-1;
                end
            end
            planes=Markers;
        end
       
        function planes=FindLines(obj,eval)
            Markers=zeros(obj.Length,1);
            counter=0;
            while(length(find(Markers==0))>0)
                unmarked=find(Markers==0);
                pc=Cloud(obj.Points(unmarked,:));
                ind=pc.FindOneLine(eval);
                if ~isempty(ind)
                    counter=counter+1;
                    Markers(unmarked(ind))=counter;
                else
                    Markers(unmarked)=-1;
                end
            end
            planes=Markers;
        end
        
    end
end
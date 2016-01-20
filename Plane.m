classdef Plane
    %class of plane, all 3D points are [x,x,x]
    properties (SetAccess=protected)
        Normal;%the normal of the plane
        Position;%one point in the plane
        Edges;%used when ploting the plane
        SamplePoints=3;%need 3 points to determine a specific plane
    end
    methods
        %%%%%%%%%%%
        function obj=Plane(pointA,pointB,pointC)
            obj.Normal=cross(pointA-pointB,pointC-pointB);
            obj.Normal=obj.Normal/norm(obj.Normal);%normalization
            obj.Position=pointA;
            if size(pointA,1)==3%incase user inputs [x;x;x] vectors
                obj.Normal=obj.Normal';
                obj.Position=obj.Position';
            %elseif size(pointA,2)~=3 || size(pointA,1)~=1
            %    error('all three points must be 3D [x,x,x] vectors');
            end
        end
        %%%%%%%%%%%%%%%%%
        function norm=getNorm(obj)
            norm=obj.Normal;
        end
        %%%%%%%%%%%%%%%%%
        function pos=getPos(obj)
            pos=obj.Position;
        end
        %%%%%%%%%%%%%%%%%
        function distance = Pnt2PlaneDist(obj,pointA)
            %could be positive or negative
            if size(pointA,1)==3
                pointA=pointA';
            end
            distance=(pointA-obj.Position)*obj.Normal';
        end
        %%%%%%%%%%%%%%%%%%
    end
end
    
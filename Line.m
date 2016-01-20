classdef Line
    properties %(SetAccess=protected)
        Direction;%direction of the line End-Start
        Start;%starting point
        End;%ending point
    end
    methods
        function obj=Line(PointA,PointB)
            obj.Start=PointA;
            obj.End=PointB;
            obj.Direction=(obj.End-obj.Start);
            obj.Direction=obj.Direction/norm(obj.Direction);%normalization
        end
        function distance = Pnt2LineDist(obj,pointA)
            distance=norm(pointA-(pointA*obj.Direction')*obj.Direction);
        end
        %function distances = Cloud2LineDist(obj,CloudA)
        %    CloudA*obj.Direction;
    end
end
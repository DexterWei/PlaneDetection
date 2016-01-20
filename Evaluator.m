%function score = ScorePlaneInCloud(pc,plane,)
 classdef Evaluator
     properties
         Margin;%the distance threshold from the shape
         MinPntNum;
     end
     methods
         function obj = Evaluator(m,p)
             obj.Margin=m;
             obj.MinPntNum=p;
         end
         function [score,InPlaneIndex] = ScorePlaneInCloud(obj,pc,plane)
             distances = pc.Plane2CloudDist(plane);
             InPlaneIndex= find(abs(distances)<=obj.Margin);
             score = length(InPlaneIndex);
         end
         function [score,InLineIndex]=ScoreLineInCloud(obj,pc,line)
             distances=pc.Line2CloudDist(line);
             InLineIndex = find(distances<=obj.Margin);
             score = length(InLineIndex);
         end
         function index = FindConnectedInCloud(obj,pc)
             len=pc.Length;
             Mark=zeros(len,1);%0 means unchecked;
             counter=0;%count how many groups has been detected;
             while (length(find(Mark==0))>0)
                 unmarked=find(Mark==0);%all unmarked index
                 num=length(unmarked);
               %  num
                 i=unmarked(randi(num));
                 the_point=pc.Points(i,:);%pick an unmarked point
                 distances=pc.Point2CloudDist(the_point);%calculate the distances to this point
                 surrounding=find(distances<obj.Margin);%find the surrounding points(index)
                 surrounding(find(surrounding==i))=[];%remove the the_point itself
                 if isempty(surrounding)
                     Mark(i)=-2;%mark -2 for totally isolated points
                 else
                     Mark(i)=-1;
                     counter=counter+1;%a new group found
                     while length(surrounding)>0
                         if Mark(surrounding(1))==0;
                            
                             Mark(surrounding(1))=-1;%mark as buffer
                              surrounding(1)=[];
                              counter=counter+0;%no new group found
                         elseif Mark(surrounding(1))==-1;
                             surrounding(1)=[];
                         else
                             the_mark=Mark(surrounding(1));
                             
                             Mark(find(Mark==the_mark))=-1;
                             Mark(find(Mark>the_mark))=Mark(find(Mark>the_mark))-1;%all the markers higher than 
                                                                        %the mark should minus 1 to make sure no empty markers
                          %   surrounding(find(Mark(surrounding)==the_mark))=[];
                             counter=counter-1;%an old group merged
                         end
                     end
                     Mark(find(Mark==-1))=counter;
                 end
             
             end
             group_population=zeros(1,counter);
             for i=1:counter
                 group_population(i)=sum(Mark==i);
             end
             qualified_groups=find(group_population>=obj.MinPntNum);
             if ~isempty(qualified_groups)
                 num_groups=length(qualified_groups);
                 index=cell(1,num_groups);
                 for i=1:num_groups
                     index{i}=find(Mark==qualified_groups(i));
                 end
             else
                 index={};
             end
         end
     end
 end
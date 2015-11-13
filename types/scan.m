% SCAN
%
% @brief    
% @author   Brian Cairl
% @date     October 19, 2015
classdef scan
    
    properties
        timestamp   = 0;
        points      = [];
    end
    
    
    
    methods

        
        % knearest
        %
        % @brief    Returns indices of K nearest points in 'OTHER'
        function [idx,d] = knearest(self,other,k)
            [idx,d] = knnsearch(self.points.',other.points.','K',k);
        end
        
        
        % SUBSET
        %
        % @brief    Returns a subset of a scan
        function sub = subset(self,sel)
            sub             = scan;
            sub.timestamp   = self.timestamp;
            sub.points      = self.points(:,sel);
        end
        
        
        % SUBSAMPLE
        %
        % @brief    Returns a subsampled scan
        function sub = subsample(self,skip)
            sub             = scan;
            sub.timestamp   = self.timestamp;
            sub.points      = self.points(:,1:skip:end);
        end
        
        
        % SIZE
        %
        % @brief    Returns a subset of a scan
        function n = size(self,skip)
            n = size(self.points,2);
        end       
        
        
        % GETPOINTS
        %
        % @brief    Returns the XYZ coordinates of a scan
        function X = getpoints(self,varargin)
            if  numel(varargin) % for particular elements
                X = self.points(1:3,varargin{1});
            else
                X = self.points(1:3,:);
            end
        end

        
        % GETNORMALS
        %
        % @brief    Returns the UVW coordinates of a scan
        function X = getnormals(self,varargin)
            if  numel(varargin) % for particular elements
                X = self.points(4:6,varargin{1});
            else
                X = self.points(4:6,:);
            end
        end
        
        
        
        % ISEMPTY
        % 
        % @brief    Returns true if scan is empty;
        function b = isempty(self)
           b = isempty(self.points); 
        end
        
        
        % SCANREAD
        %
        % @brief    Reads a frame from an opened data file
        %
        % @input    FID         associated file handle
        % @input    DIM         dimension of the points for each scan {3 or 6}
        %
        % @return   S           a timestamped scan structure with the following
        %                       member variables:
        %                           S.timestamp
        %                           S.points 
        %
        %           n           size of the scan (number of points)
        function [self,n]   = scanread(self,fid,dim)
            self.timestamp  = fread(fid,[1,1],'float32');
            n               = fread(fid,[1,1],'uint32');
            self.points     = fread(fid,[dim,n],'float32');
        end
        
        
        % VIEW (shorthand for view_scan)
        function view(self,varargin)
            view_scan(self,varargin{:});
        end
        
        
        
        % SCAN
        function s = scan(varargin)
            while numel(varargin)
               if       strcmpi(varargin{1},'POINTS');
                    s.points = varargin{2};
               elseif   strcmpi(varargin{1},'TIMESTAMP');
                    s.timestamp = varargin{2};
               end
               varargin(1:2) = [];
            end
        end
        
    end
    
end


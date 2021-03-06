% SCAN
%
% @brief    
% @author   Brian Cairl
% @date     October 19, 2015
classdef scan
    
    properties
        timestamp   = 0;
        points      = [];
        normals     = [];
        colors      = [];
    end
    
    
    
    methods

        
        
        % RANDOM
        function self = random(self,n)
           U    = randn(3,n)+ones(3,n); U = U./repmat( sum(U,1), 3, 1);
           X    = randn(3,n)*10;
           C    = rand(3,n);
           self = scan('Points',X,'Normals',U,'Colors',C);
        end
        
        
        % ISEMPTY
        % 
        % @brief    Returns true if scan is empty;
        function b = isempty(self)
           b = isempty(self.points); 
        end
        
        
        % ISCOLORED
        function b = iscolored(self)
           b = ~isempty(self.colors); 
        end
        
        
        % ISSURF
        function b = issurf(self)
           b = ~isempty(self.normals); 
        end
        
        
        % ISSCAN
        function b = isscan(self)
           b = strcmpi(class(self),'scan');
        end        
        
        
        % KNEAREST
        %
        % @brief    Returns indices of K nearest points in 'OTHER'
        function [idx,d] = knearest(self,other,k)
            if  ~isnumeric(other)
                % Scan to Scan
                [idx,d] = knnsearch(other.points.',self.points.','K',k);
            else
                % Point to Scan
                [idx,d] = knnsearch(other.',self.points.','K',k);
            end
                
        end
        
        
        % SUBSET
        %
        % @brief    Returns a subset of a scan
        function sub = subset(self,sel)
            sub             = scan;
            sub.timestamp   = self.timestamp;
            sub.points      = self.points(:,sel);
            
            % Colors
            if self.iscolored();
               sub.colors   = self.colors(:,sel); 
            end
            
            % Normals
            if self.issurf();
               sub.normals  = self.normals(:,sel); 
            end
        end
        
        
        % SUBSAMPLE
        %
        % @brief    Returns a subsampled scan
        function sub = subsample(self,skip)
            sel = 1:skip:size(self);
            sub = self.subset(sel);
        end
        
        
        % SIZE
        %
        % @brief    Returns a subset of a scan
        function n = size(self)
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
            if  issurf(self)
                if  numel(varargin) % for particular elements
                    X = self.normals(1:3,varargin{1});
                else
                    X = self.normals(1:3,:);
                end
            else
                error('Cloud has no associated normal vectors.')
            end
        end
        
        
        % GETCOLORS
        %
        % @brief    Returns the RGB color of scan points
        function X = getcolors(self,varargin)
            if  iscolored(self)
                if  numel(varargin) % for particular elements
                    X = self.points(1:3,varargin{1});
                else
                    X = self.points(1:3,:);
                end
            else
                error('Cloud has no associated color vectors.')
            end
        end
        
        
        
        % EMPLACE_NORMALS
        function [self,NNi] = emplace_normals(self,varargin)
            [self.normals,NNi] = est_normals(self,varargin{:});
        end
        
        
       
         % VIEW (shorthand for view_scan)
        function view(self,varargin)
            viewscan(self,varargin{:});
        end
        
        
        % ROTATE
        function self   = rotate(self,r)
            if size(r,2)==4
                R = vrrotvec2mat(r);
            else
                R = r;
            end
            
            self.points  = R*self.points;
           
           if   issurf(self)
                self.normals = R*self.normals;
           end
        end
        
        
        
        
        % OFFSET
        function self   = translate(self,r)
            self.points = self.points + repmat(r,1,size(self)); 
        end
        
        
        
        
        % SCAN
        function s = scan(varargin)
            if  nargin == 1
                s = varargin{1};
            else
                while numel(varargin)
                   if       strcmpi(varargin{1},'POINTS');
                        s.points    = vecdimcheck(varargin{1},3,varargin{2});
                   elseif   strcmpi(varargin{1},'NORMALS');
                        s.normals   = vecdimcheck(varargin{1},3,varargin{2});
                   elseif   strcmpi(varargin{1},'COLORS');
                        s.colors    = vecdimcheck(varargin{1},3,varargin{2});
                   elseif   strcmpi(varargin{1},'TIMESTAMP');
                        s.timestamp = scalarcheck(varargin{1},varargin{2});
                   else
                        error(['Unknown parameter : ',varargin{1}]);
                   end
                   varargin(1:2) = [];
                end
            end
        end
        
         
    end
end
function var = vecdimcheck(str,d,var)
    if  size(var,1)~=d
        error( sprintf('[%s] field must be a %d-by-N matrix',str,d) ); %#ok<SPERR>
    end
end
function var = scalarcheck(str,var)
    if  any([1,1]~=size(var))
        error( sprintf('[%s] field must be a scalar',str) ); %#ok<SPERR>
    end
end


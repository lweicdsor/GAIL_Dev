% cubSobol_g_in_param: cubSobol_g's input parameter object
%
% Examples
%
% >> in_param = gail.cubSobol_g_in_param()
%    Warning: Function f must be a function handle. ***
%             f: @(x)exp(-100*(x-0.5).^2)
%             a: 0
%             b: 1
%        abstol: 1.0000e-06
%           nlo: 10
%           nhi: 1000
%          nmax: 10000000
%         ninit: 100
%
%
% >> f = @(x) x.^2; in_param = gail.cubSobol_g_in_param(f)
%    in_param = ***
%             f: @(x)x.^2
%             a: 0
%             b: 1
%        abstol: 1.0000e-06
%           nlo: 10
%           nhi: 1000
%          nmax: 10000000
%         ninit: 100
%
%
%  To get a struct:
%  >> out_param = in_param.toStruct()
%  out_param = 
% 
%             f: @(x)x.^2
%             a: 0
%             b: 1
%        abstol: 1.0000e-06
%           nlo: 10
%           nhi: 1000
%         ninit: 100
%          nmax: 10000000
%
%
% To get a structure with selected fields (and ignore properties that do not exist):
% >> out_param = in_param.toStruct({'f', 'a', 'b','c'})
%  out_param =
%
%     f: @(x)x.^2
%     a: 0
%     b: 1
%
classdef cubSobol_g_in_param < gail.gailMD_in_param
    %% data
    properties % public      
        mmin
        mmax
        toltype
        theta
        cv
        d
    end % properties
     
    %% methods
    methods % public
        % constructor
        function out_param = cubSobol_g_in_param(varargin)
            % parse the input to a gail function
            in = cell(0);
            if nargin >= 1
                in = varargin{1};
            end
            out_param = out_param@gail.gailMD_in_param(in);
            out_param = out_param.set_input_field_names(...
              {'a','b','abstol','nlo','nhi','nmax','flip'}...
            );
            % out_param.get_input_field_names();
            %% Default parameter values
            default = out_param.get_default();
            default.flip = 0;
        
            %% parse inputs
            out_param = out_param.parse_inputs(default, varargin{:});
            
            %% validate inputs
            out_param = out_param.validate_inputs();
            
        end % constructor

        function out_param = toStruct(out_param,varargin)
            out_param = toStruct@gail.gailMD_in_param(out_param,{'f', 'a', 'b','abstol','nlo','nhi','ninit','nmax'});
        end
        
        function out_param = validate_inputs(out_param)
            out_param = validate_inputs@gail.gailMD_in_param(out_param);
        end

    end % methods
    
    methods (Access = protected) % seen by subclasses
        
        % customize display order of properties (data) in an instance
        function propgrp = getPropertyGroups(~)
            proplist = {'f', 'a', 'b','abstol','nlo','nhi','nmax','ninit'};
              %  'exitflag','npoints','errest','volumeX', 'tauchange', 'intervals'};
            propgrp = matlab.mixin.util.PropertyGroup(proplist);
        end
    end % methods (protected)
    
    
end % classdef

%% other functions
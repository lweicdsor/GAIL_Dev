function [fappx, out_param] = par_funappx_g(workers,varargin)
% par_funappx_g Executes GAIL's funappx_g using MATLAB Parallel Toolbox
%
%   fappx = par_funappx_g(w, f) approximates a function f by applying the
%   GAIL algorithm funappx_g on w even subintervals of [0,1] using a
%   parallel pool of w MATLAB workers. If w equals 1, then no parallel
%   pool is created and it is equivalent to calling fappx = funappx_g(f).
%
%   Input Arguments
%
%     w --- number of MATLAB parallel pool workers, positive integer
%
%     Refer to documentation of funappx_g for additional optional inputs
%
%
%   Output Arguments
%
%     Same as the outputs of funappx_g. Refer to documentation of funappx_g
%
%
%   Example 1:
%
%   Create a pool of 8 workers:
%      myCluster = parcluster('local')
%      myCluster.NumWorkers = 8;
%      saveProfile(myCluster);
%      if isempty(gcp), parpool; end
%
%   >> f = @(x) x.^2;
%   >> [fappx, out_param] = par_funappx_g(4,f,-2,2,1e-7,20,20); out_param
%   out_param =
%
%            f: @(x)x.^2
%            a: -2
%            b: 2
%       abstol: 1.0000e-07
%          nlo: 20
%          nhi: 20
%        ninit: 20
%         nmax: 10000000
%      maxiter: 1000
%     exitflag: [0 0 0 0 0]
%         iter: 12
%      npoints: 32769
%       errest: ***e-08
%       ***
%
%  >> x=-2:1e-7:2; f = @(x) x.^2; err = max(abs(f(x)-fappx(x))); err < 1e-7
%  ans =
%    1
%
%
%  To release workers:
%   delete(gcp);
%
%
%   See also FUNAPPX_G, PAR_FUNMIN_G
%
%
%  References
%
%   [1]  Sou-Cheng T. Choi, Yuhan Ding, Fred J.Hickernell, Xin Tong, "Local
%   Adaption for Approximation and Minimization of Univariate Functions,"
%   Journal of Complexity, 2016. To appear.
%
%   [2]  Nick Clancy, Yuhan Ding, Caleb Hamilton, Fred J. Hickernell, and
%   Yizhi Zhang, "The Cost of Deterministic, Adaptive, Automatic
%   Algorithms: Cones, Not Balls," Journal of Complexity 30, pp. 21-45,
%   2014.
%
%   [3]  Sou-Cheng T. Choi, Yuhan Ding, Fred J. Hickernell, Lan Jiang,
%   Lluis Antoni Jimenez Rugama, Xin Tong, Yizhi Zhang and Xuan Zhou,
%   GAIL: Guaranteed Automatic Integration Library (Version 2.2) [MATLAB
%   Software], 2017. Available from http://gailgithub.github.io/GAIL_Dev/
%
%   If you find GAIL helpful in your work, please support us by citing the
%   above papers, software, and materials.
%

%% preprocessing
in_param = gail.funappx_g_in_param(varargin{:});
out_param = in_param.toStruct();
f = in_param.f;
MATLABVERSION = gail.matlab_version;

a = out_param.a;
b = out_param.b;
h = (b-a)/workers;
ou = cell(1,workers);
div = min(4, workers);
nmax = max(5,ceil(out_param.nmax/div));
%% parallel loop
parfor (i=1:workers, double(workers>1))
    out_param_subinterval = out_param;
    out_param_subinterval.a = a+(i-1)*h;
    out_param_subinterval.b = out_param_subinterval.a + h;
    out_param_subinterval.nmax = nmax;
    out_param_subinterval.output_x = 1;
    [~,out] = funappx_g(f, out_param_subinterval);
    ou{i} = out;
end

%% postprocessing
out_all = ou{1};
out_all.b = out_param.b;
x = ou{1}.x;
y = ou{1}.y;
for i = 2:workers,
  out_all.ninit = out_all.ninit + ou{i}.ninit;
  out_all.nmax = out_all.nmax + ou{i}.nmax;
  out_all.iter =  max(out_all.iter, ou{i}.iter);
  out_all.npoints = out_all.npoints + ou{i}.npoints - 1;
  out_all.errest =  max(out_all.errest, ou{i}.errest);
  out_all.exitflag = max(out_all.exitflag, ou{1}.exitflag);
  x = [x ou{i}.x(2:end)];
  y = [y ou{i}.y(2:end)];
end
if MATLABVERSION >= 8.3
    fappx = griddedInterpolant(x,y,'linear');
else
    fappx = @(t) ppval(interp1(x,y,'linear','pp'), t);
end;
out_param = out_all;
if (in_param.output_x ~= 0)
  out_param.x = x;
  out_param.y = y;
else
  out_param = rmfield(out_param,'x');
  out_param = rmfield(out_param,'y');
end

% for i = 1:workers,
%   xx = rand(10000,1)*(ou{i}.b-ou{i}.a)+ou{i}.a;
%   actualerr = max(abs(fappx(xx)-f(xx)));
%   if actualerr > abstol, keyboard, end
% end

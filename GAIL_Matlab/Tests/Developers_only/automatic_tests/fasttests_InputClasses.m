% fasttests_InputClasses: fast tests for input classes

%% CALL DOCTESTS
%format short
%tic; doctest gail.gail_in_param; time=toc
%tic; doctest gail.gail1D_in_param; time=toc
%tic; doctest gail.gailMD_in_param; time=toc

%tic; doctest gail.integral_g_in_param; time=toc
%tic; doctest gail.funappx_g_in_param; time=toc
%tic; doctest gail.funmin_g_in_param; time=toc
%tic; doctest gail.cubMC_g_in_param; time=toc

%format long
warning('off', 'GAIL:fParam:noFunctionInput');
tic; doctest gail.errorParam; time = toc
tic; doctest gail.fParam; time = toc
tic; doctest gail.cubParam; time = toc
tic; doctest gail.cubOut; time = toc
tic; doctest gail.cubLatticeParam; time = toc
tic; doctest gail.cubBayesLatticeParam; time = toc
tic; doctest gail.cubBayesLatticeOut; time = toc
tic; doctest gail.meanYParam; time = toc
tic; doctest gail.meanYOut; time = toc
warning('on', 'GAIL:fParam:noFunctionInput');

%% CALL UNIT TESTS

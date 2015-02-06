%ut_convtest_funappx_g unit test for conv. test of funappx_g
classdef ut_convtest_funappx_g < matlab.unittest.TestCase

  methods(Test)
               
    function convtest_computationalcost_funappx_g(testCase)
      [npoints,~,~,npointsglobal,~,~]=funappx_convtest;
      testCase.verifyGreaterThanOrEqual(npointsglobal,npoints);
    end
    
    function convtest_errorest_funappx_g(testCase)
      [~,errest,~,~,errestglobal,~]=funappx_convtest;
      testCase.verifyGreaterThanOrEqual(errest,errestglobal);
    end
    
     function convtest_timecost_funappx_g(testCase)
      [~,~,t,~,~,tglobal]=funappx_convtest;
      testCase.verifyGreaterThanOrEqual(tglobal(5),t(5));
      testCase.verifyGreaterThanOrEqual(sum(t<tglobal),5);
    end
    
  end
end
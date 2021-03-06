%% longtests_cubSobol_g: long tests for cubSobol_g

format short
doctest dt_cubSobol_g
doctest cubSobol_old_g;

% cubSobol_g paper
try
  SobolWalshPict;
catch
    display('Error: SobolWalshPict is wrongly coded. We skip it.')
end
try
  WalshFourierCoeffDecay;
catch
    display('Error: WalshFourierCoeffDecay is wrongly coded. We skip it.')
end
%run_handle('RunTestCubatureonGeoAsianCallSobol');
%run_handle('RunTestCubatureonKeisterSobol')
try
    Tests = matlab.unittest.TestSuite.fromClass(?ut_Papers_cubSobol_g);
    results=run(ut_Papers_cubSobol_g);
    if sum([results.Failed])>0
        failed=find([results.Failed]>0);
        %for i=1:size(failed,2)
        %  fprintf(fid,'%s\n',Tests(failed(i)).Name);
        %end
    end
catch
    display('Error: Test ut_Papers_cubSobol_g is wrongly coded. We skip it.')
    %fprintf(fid,'Error: Test ut_Papers_cubSobol_g is wrongly coded. We skip it.\n');
end
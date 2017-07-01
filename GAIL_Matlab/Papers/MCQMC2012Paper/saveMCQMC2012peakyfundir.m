function saveMCQMC2012peakyfundir(fname,xsample)
<<<<<<< HEAD
GAILPATH = GAILstart(0);
outputfolder =  [GAILPATH,'OutputFiles',filesep,'MCQMC2012PaperOutput'];
if exist(outputfolder) ~= 7,
  mkdir(outputfolder);
end
fullfilename = strcat(outputfolder, filesep', fname);
=======
[GAILPATH,~,PATHNAMESEPARATOR] = GAILstart(0);
outputfolder =  [GAILPATH,'OutputFiles',PATHNAMESEPARATOR,'MCQMC2012PaperOutput'];
if exist(outputfolder) ~= 7,
  mkdir(outputfolder);
end
fullfilename = strcat(outputfolder, PATHNAMESEPARATOR', fname);
>>>>>>> FakeMaster
save(fullfilename,'xsample')
end
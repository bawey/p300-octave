function summary = P3Summary(functions, confusion, totalPeriods)
  
  summary.functions=functions;
  summary.confusionMatrix=confusion;
  summary.totalPeriods=totalPeriods;
  
  summary=class(summary, 'P3Summary');
  
endfunction;
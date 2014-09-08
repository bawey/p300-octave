function summary = P3Summary(functions, confusion)
  
  summary.functions=functions;
  summary.confusionMatrix=confusion;
  
  summary=class(summary, 'P3Summary');
  
endfunction;
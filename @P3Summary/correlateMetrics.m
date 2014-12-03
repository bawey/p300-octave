%function correlateMetrics(sumt, sumxv=sumt)

function info = correlateMetrics(sumt, sumxv=sumt)
    [ord_test       , scr_test]         = sortResults(sumt  , 'correctSymbols');
    [ord_accuracy   , scr_accuracy]     = sortResults(sumxv , 'accuracy');
    [ord_f1         , scr_f1]           = sortResults(sumxv , 'f1');
    [ord_precision  , scr_precision]    = sortResults(sumxv , 'precision');
    [ord_recall     , scr_recall]       = sortResults(sumxv , 'recall');
    [ord_xv_symbols , scr_xv_symbols]   = sortResults(sumxv , 'correctSymbols');
    [ord_mse        , scr_mse]          = sortResults(sumxv , 'mse');
    [ord_mste       , scr_mste]         = sortResults(sumxv , 'mste');
    
    ord_test        =   ord_test(:, 3);
    
    %we want test scores to be ordered by the method, ie. 1st method, 2nd method etc.
    [x y] = sort(ord_test);
    scr_test = scr_test(y);
    

    xv_symbols  =   [ord_xv_symbols(:, 3)   ,    scr_xv_symbols ];  
    accuracy    =   [ord_accuracy(:, 3)     ,    scr_accuracy   ];
    f1          =   [ord_f1(:, 3)           ,    scr_f1         ];
    precision   =   [ord_precision(:, 3)    ,    scr_precision  ];
    recall      =   [ord_recall(:, 3)       ,    scr_recall     ];
    mse         =   [ord_mse(:, 3)          ,    scr_mse        ];
    mste        =   [ord_mste(:, 3)         ,    scr_mste        ];

    mse_test            = [mse(:,2), scr_test(mse(:,1))];
    mste_test           = [mste(:,2), scr_test(mste(:,1))];
    xv_symbols_test     = [xv_symbols(:,2), scr_test(xv_symbols(:,1))];
    accuracy_test       = [accuracy(:,2), scr_test(accuracy(:,1))];
    f1_test             = [f1(:,2), scr_test(f1(:,1))];
    recall_test         = [recall(:,2), scr_test(recall(:,1))];
    precision_test      = [precision(:,2), scr_test(precision(:,1))];
    
%      method_scores=ones(size(scr_test));
    
    info = struct();
    info.corr = struct();
    info.data = struct();
    
    for(m = {'correctSymbols', 'accuracy', 'mse', 'f1', 'precision', 'recall', 'conf', 'overconf'})
        [ord   , scr_own]     = sortResults(sumxv , m{:});
        ord = ord(:,3);
        headon = [scr_own, scr_test(ord)];
        correl = corr(headon)(1,2);
%          fprintf('%s has correlation of %.4f \n', m{:}, correl);
        info.corr.(m{:})=correl;
        info.data.(m{:})=headon;
        
%          scr_own.*=correl;
%          if(ismember(m{:}, {'correctSymbols'}))
%              scr_own./=sumxv.totalPeriods;
%          
%          endif;
    %scr own was ordered according to its value. need to reorded according to method number
    
%      [x y] = sort(ord);
%          if(correl>0.3)
%              method_scores.*=scr_own(y);
%          endif;
    endfor;
    
%      sumxv.totalPeriods
%      
%      [value index] = max(method_scores)
%      
%      stringify(sumxv.functions.trainTest{index})

    
    

    
endfunction;

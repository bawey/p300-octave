%% ###############################
%%  ClassifiersBag(X, y, dpc=60, classifierFunc, varargin)
%%      X - train data
%%      y _ labels
%%      classifierFunc - classifier 'constructor' handle
%%      varargin - clasifier 'constructor's'' arguments
%% ###############################
function bag = ClassifiersBag(X, y, dpc=60, classifierFunc, varargin)

    bag.classifiers={};
    bag.std_weight=dpc;
    bag.last_weight=dpc;
    
    pieceX=[];
    piecey=[];
    for(i=1:rows(X))
        if(length(piecey)<dpc)
            pieceX=[pieceX; X(i,:)];
            piecey=[piecey; y(i,:)];
        else
            bag.classifiers{end+1}=feval(classifierFunc, pieceX, piecey, varargin{:});
            pieceX=[];
            piecey=[];
        endif;
    endfor;
    
    %some left-overs from the training data
    if(~isempty(piecey))
        bag.classifiers{end+1}=feval(classifierFunc, pieceX, piecey, varargin{:});
        bag.last_weight=length(piecey);
    endif;

    fprintf('Using a bag of %d classifiers. %d training samples spread in %d-long pieces and %d-long for the last classifier. \n', 
            length(bag.classifiers), rows(X), bag.std_weight, bag.last_weight);
        
    bag=class(bag, 'ClassifiersBag');
endfunction;

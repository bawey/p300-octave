%assumes the data is centered and hence no mean needs to be subtracted
%Kaiser (KSR) method
        %9. Jolliffe, I.T., 1986. Principal Component Analysis, New York.
function steps = featsComputePCAWithKSR(tfeats, tlabels, ksr_threshold=1.0)
    
%      printf('computing PCA with KSR threshold: %.2f\n', ksr_threshold);
    
    C = cov(tfeats);
    [V,D] = eig(C);


    % sort eigenvectors desc
    %[D, i] = sort(diag(D), 'descend');
    %V = V(:,i);
        
    %V=V(:, 1:components);

        
    V=V(:, diag(D)>=ksr_threshold);
        
%      fprintf('Picked %d PCs.\n', columns(V));
        
    % what would you do to project on pc1:components and back?
    % feats=feats*V*V';
      
    step_one=struct();
    step_one.functionHandle=@mtimes;
    %first argument will be the features set
    %step_one.arguments={V*V'};
    step_one.arguments={V};
    
%      printf('sizeof projection matrix: %d x %d, size of V: %d x %d, size of feats: %d x %d \n', size(V*V'), size(V), size(tfeats));
    
    steps={step_one};

endfunction;
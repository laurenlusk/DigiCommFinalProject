function [e_vec, e_val, sv, sv_th] = analyzeGram(data,options)

    gram = data'*data;
    % calculates eigenvectors and eigenvalues
    [e_vec_tmp, e_val_tmp] = eig(gram, 'vector');
    [e_val, idx] = sort(e_val_tmp,'descend');
    e_vec = e_vec_tmp(:,idx); % Columns are eigenvectors for each eigenvalue
    % calculates all singular values
    sv = sort(svd(gram),'descend');
    % calculates the singular values used for reconstruction
    sv_th = zeros(size(sv));
    if options.applyThreshold
        for p = 1:length(sv)
           if (sv(p) > options.threshold.lower)...
                   && (sv(p) < options.threshold.upper)
               sv_th(p) = sv(p);
           end
        end
    elseif options.applySingularVal
        if options.svdVal ~=0
            for i = options.svdVal        
                sv_th = sv(i);
            end
        end
    else
        sv_th = sv;
    end
end
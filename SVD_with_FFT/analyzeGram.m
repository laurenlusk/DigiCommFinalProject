function [sv, sv_th] = analyzeGram(data,options)

    gram = data'*data;
    sv = sort(svd(gram),'descend');
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
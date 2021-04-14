function [s] = seperateSVD(choice, w, k)

    if strcmp(choice, "Threshold")
        print("Here")
    elseif strcmp(choice, "Manual")
        s.weak = w;
        s.strong = 1:k;
        s.strong(w) = [];
    end

end
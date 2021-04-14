function [e_vec, e_val, sv] = analyzeGram(data)

    gram = data'*data;
    [e_vec_tmp, e_val_tmp] = eig(gram, 'vector');
    [e_val, idx] = sort(e_val_tmp,'descend');
    e_vec = e_vec_tmp(:,idx); % Columns are eigenvectors for each eigenvalue
    
    sv = sort(svd(gram),'descend');

end
function plot_eVals(ev, k, tle)

    plot(ev)
    title(tle)
    S = sprintf('%d*', 1:k);
    C = regexp(S, '*', 'split');
    lgd_1 = legend(C{1:k},'Location','best');
    title(lgd_1,sprintf('Eigenvalues'))

end
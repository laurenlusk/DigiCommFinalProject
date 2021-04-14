function rr = filterSig(r, n, k)

    h = firpm(50,[0 .3 .35 .5]*2,[1 1 0 0]);
    rr = zeros(n, k);
    for col=1:k
        rr(:,col) = filter(h,1,r(:,col)) ;
    end

end
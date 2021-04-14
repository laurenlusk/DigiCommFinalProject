function [f_indx, n_indx] = calc_locations(center,REDUCE,TOL,spectro,win,N)
    
    % Preallocate
    f_indx = zeros(18,1);
    n_indx = zeros(18,1);
    
    % Initialize
    f_indx(1:2,1) = center(:,1);
    n_indx(1:2,1) = center(:,2);

    % Height in points of center rectangle
    H = n_indx(2) - n_indx(1);
    % Width in points of center rectangle
    W = f_indx(2) - f_indx(1);
    
    % Points between rectangles (vertical)
    BufferH = round(TOL*H); 
    % Points between rectangles (horizontal)
    BufferW = round(TOL*W); 

    % Rect 2 (Top Middle)
    f_indx(3) = f_indx(1);
    f_indx(4) = f_indx(2);
    n_indx(3) = n_indx(2) + BufferH;
    n_indx(4) = n_indx(3) + round(REDUCE.N*H);

    % Rect 3 (Top Right Corner)
    f_indx(5) = f_indx(2) + BufferW;
    f_indx(6) = f_indx(5) + round(REDUCE.E*W);
    n_indx(5) = n_indx(3);
    n_indx(6) = n_indx(4);

    % Rect 4 (Right Middle)
    f_indx(7) = f_indx(5);
    f_indx(8) = f_indx(6);
    n_indx(7) = n_indx(1);
    n_indx(8) = n_indx(2);

    % Rect 5 (Bottom Right Corner)
    f_indx(9) = f_indx(5);
    f_indx(10) = f_indx(6);
    n_indx(10) = n_indx(7) - BufferH;
    n_indx(9) = n_indx(10) - round(REDUCE.S*H);

    % Rect 6 (Bottom Middle)
    f_indx(11) = f_indx(3);
    f_indx(12) = f_indx(4);
    n_indx(11) = n_indx(9);
    n_indx(12) = n_indx(10);

    % Rect 7 (Bottom Left Corner)
    f_indx(14) = f_indx(1) - BufferW;
    f_indx(13) = f_indx(14) - round(REDUCE.W*W);
    n_indx(13) = n_indx(9);
    n_indx(14) = n_indx(10);

    % Rect 8 (Left Middle)
    f_indx(15) = f_indx(13);
    f_indx(16) = f_indx(14);
    n_indx(15) = n_indx(7);
    n_indx(16) = n_indx(8);

    % Rect 9 (Top Left Corner)
    f_indx(17) = f_indx(13);
    f_indx(18) = f_indx(14);
    n_indx(17) = n_indx(3);
    n_indx(18) = n_indx(4); 
    
    % Boundary Checking (cuttoff anything out of spectogram bounds)
    tmp = f_indx > length(spectro.rError.f);
        f_indx(tmp) = length(spectro.rError.f);
    tmp = f_indx  < 1;
        f_indx(tmp) = 1;
    tmp = n_indx < 1;
    	n_indx(tmp) = 1;

    % Boundary Checking (cuttoff anything past end transient)  
    trans_B = win.w1.m_ovr*ceil((N - win.w1.m_ovr)/win.w1.m_ovr - 1) + 1;
    [~, trans_B_Indx] = min(abs(spectro.rError.t - trans_B));

    tmp = n_indx > trans_B_Indx;
        n_indx(tmp) = trans_B_Indx;
    
end
function [center] = obtain_center(points, spectro)

    if (isempty(points)) % Dynamically choosing center area points
        fprintf('Please choose center box diagonals.\n');
        [x,y] = ginput(2);
    else % Using function input as center area points
        x = spectro.rError.f(points(1:2,1));
        y = spectro.rError.t(points(1:2,2));
    end

    % Return center area coordinates
    center = zeros(2,2);
    [~, center(1,1)] = min(abs(spectro.rError.f - min(x)));
    [~, center(2,1)] = min(abs(spectro.rError.f - max(x)));
    [~, center(1,2)] = min(abs(spectro.rError.t - min(y)));
    [~, center(2,2)] = min(abs(spectro.rError.t - max(y)));

end
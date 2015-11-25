function key = create_key(varargin)
    % Determine the number of keys to be generated.
    if nargin == 0
        num = 1;
    else
        num = varargin(1);
    end

    key = zeros(64, num);

    for k = 1:num
        this_key = randi([0 1], 7, 8);
        this_key = [this_key; mod(sum(this_key), 2)];
        key(:, k) = this_key(:);
    end
end

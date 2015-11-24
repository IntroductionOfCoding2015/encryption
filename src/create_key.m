function key = create_key(varargin)
    % Determine the number of keys to be generated.
    if nargin == 0
        num = 1;
    else
        num = varargin(1);
    end

    key = randi([0 1], 64, num);
end

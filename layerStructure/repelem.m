function y = repelem(x,z)
    a=diff(x);
    y= zeros(1, sum(z));
    y(sum(z)-cumsum(z,'reverse') + 1) = [x(1),a];
    y = cumsum(y);
    
function subsampleerrorbar(x,y,yerr)

if length(yerr) > 100
    n = round(length(yerr)/100);
    yerr2 = yerr(1:n:end);
    y2 = y(1:n:end);
    x2 = x(1:n:end);
end

errorbar(x2,y2,yerr2);


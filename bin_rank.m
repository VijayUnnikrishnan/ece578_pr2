function [DEGREE_BIN] = bin_rank(DEGREE_BIN, DEGREE, idx);
for idx = 1: idx
    if(DEGREE(idx,2) == 0)
        DEGREE_BIN(1, 1) =    DEGREE_BIN(1, 1) + 1;
    elseif (DEGREE(idx,2) == 1)
        DEGREE_BIN(1, 2) =    DEGREE_BIN(1, 2) + 1;
    elseif ((DEGREE(idx,2) > 1) && (DEGREE(idx,2) < 6))
        DEGREE_BIN(1, 3) =    DEGREE_BIN(1, 3) + 1;
    elseif ((DEGREE(idx,2) > 5) && (DEGREE(idx,2) < 101))
        DEGREE_BIN(1, 4) =    DEGREE_BIN(1, 4) + 1;
    elseif ((DEGREE(idx,2) > 100) && (DEGREE(idx,2) < 201))
        DEGREE_BIN(1, 5) =    DEGREE_BIN(1, 5) + 1;
    elseif ((DEGREE(idx,2) > 200) && (DEGREE(idx,2) < 1001))
        DEGREE_BIN(1, 6) =    DEGREE_BIN(1, 6) + 1;
    elseif ((DEGREE(idx,2) > 1000) )
        DEGREE_BIN(1, 7) =    DEGREE_BIN(1, 7) + 1;
    end
end
end
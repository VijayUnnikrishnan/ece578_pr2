
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "CustomerAS";
opts.VariableTypes = "double";
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Column2 = readtable("C:\Users\14089\Downloads\20221001.as-rel2_col2.txt", opts);
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "AS_NUM";
opts.VariableTypes = "double";
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Column1 = readtable("C:\Users\14089\Downloads\20221001.as-rel2_col1.txt", opts);
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "ConType";
opts.VariableTypes = "double";
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Column3 = readtable("C:\Users\14089\Downloads\20221001.as-rel2_col3.txt", opts);
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "prefix";
opts.VariableTypes = "double";
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
routeview_prefix = readtable("C:\Users\14089\Downloads\routeviews-rv2-20221104-1400.pfx2as.orig_ext_col1", opts);
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "AS_NUM_IP";
opts.VariableTypes = "double";
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
routeview_AS = readtable("C:\Users\14089\Downloads\routeviews-rv2-20221104-1400.pfx2as.orig_ext_col2", opts);
%%###################################################################################################################
filename = 'C:\Users\14089\Desktop\ECE578-Project2.xlsx';


%%###################################################################################################################

PRO_AS_NUM = zeros(463141, 1);
PRO_AS_NUM = Column1.AS_NUM;
CUS_AS_NUM = zeros(463141, 1);
CUS_AS_NUM = Column2.CustomerAS;
AS_LNK_TYPE = zeros(463141, 1);
AS_LNK_TYPE = Column3.ConType;
RTV_PFX  = zeros(974883,1);
RTV_AS  = zeros(974883,1);
RTV_PFX = routeview_prefix.prefix;
RTV_AS  = routeview_AS.AS_NUM_IP;

num_as_1 = 1;

%Combine column 1 and column2 into single array.
%This is required to get the number of available AS
COM_AS = zeros(2*463141, 1);
COM_AS = cat(1,PRO_AS_NUM, CUS_AS_NUM);
COM_AS_SRT = sort(COM_AS);
COM_AS_UNQ = unique(COM_AS_SRT);
num_as_2 = length(COM_AS_UNQ);
%Find the number of distinct AS available;
for idx = 2: 463141
    if (PRO_AS_NUM(idx,1) ~= PRO_AS_NUM(idx-1, 1))
        num_as_1 = num_as_1 + 1;
    end
end
number_of_unique_AS = num_as_2

%Find the global degree
GLB_DEGREE = zeros(num_as_2,2);
num_as = length(COM_AS);
num_link = 0;
for idx = 1: num_as_2
    num_link = 0;
    for idx2 = 1: 463141
        if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx2, 1)) || (COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
            num_link = num_link + 1;
        end
    end
    GLB_DEGREE(idx,:) = [COM_AS_UNQ(idx, 1), (num_link )];
end
temp1 = [0,0];

%for idx = 1 : num_as_2
%    for idx1 = idx+1 : num_as_2
%        if ()
%    end
%end


GLB_DEGREE;
%Graph 2.1

GLB_DEGREE_BIN = zeros(1, 7);
GLB_DEGREE_BIN = bin_rank(GLB_DEGREE_BIN ,GLB_DEGREE,num_as_2);
%Write this to the excel
GLB_DEGREE_BIN
writematrix(GLB_DEGREE_BIN,filename,'Sheet','Rank_2','Range','B1');
writematrix(GLB_DEGREE,filename,'Sheet','GLB_DEGREE','Range','B1');
%Find the number of direct customer of each AS
num_as_1 = length(CUS_AS_NUM);
CUS_DEGREE = zeros(num_as_1,2);
num_as = 1;
num_link = 1;
for idx = 2: 463141
    if (PRO_AS_NUM(idx,1) == PRO_AS_NUM(idx-1, 1))
        if(AS_LNK_TYPE(idx,1) == 1)
            num_link = num_link + 1;
        end
    else
        CUS_DEGREE(num_as,:) = [PRO_AS_NUM(idx-1, 1), num_link];
        num_as = num_as + 1;
        if(AS_LNK_TYPE(idx,1) == 1)
            num_link = 1;
        else
            num_link= 0;
        end
    end
end

%Graph 2.2
CUS_DEGREE(num_as,:) = [PRO_AS_NUM(idx, 1), num_link];
CUS_DEGREE_BIN = zeros(1, 7);
CUS_DEGREE_BIN =  bin_rank(CUS_DEGREE_BIN ,CUS_DEGREE,num_as);
CUS_DEGREE_BIN
writematrix(CUS_DEGREE,filename,'Sheet','CUS_DEGREE','Range','B1');


%Find the AS with direct peers from column1 and column2
num_as_1 = length(CUS_AS_NUM);
PEER_DEGREE = zeros(num_as_2,2);
num_as = 1;

for idx = 1: num_as_2
    num_link = 0;
    for idx2 = 2: num_as_1
        if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx2, 1)) || (COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
            if(AS_LNK_TYPE(idx,1) == 0)
                num_link = num_link + 1;
            end
        end

    end
    PEER_DEGREE(idx,:) = [COM_AS_UNQ(idx,1), num_link ];
end
%Graph 2.3

PEER_DEGREE_BIN = zeros(1, 7);
PEER_DEGREE_BIN =  bin_rank(PEER_DEGREE_BIN ,PEER_DEGREE,num_as_2);
PEER_DEGREE_BIN
%writematrix(PEER_DEGREE_BIN,filename,'Sheet','Rank_2','Range','B3');
writematrix(PEER_DEGREE,filename,'Sheet','PEER_DEGREE','Range','B1');
%Find provider degree
num_as_1 = length(CUS_AS_NUM);
PROVIDER_DEGREE = zeros(num_as_2,2);
num_as = 1;

for idx = 1: num_as_2
    num_link = 0;
    for idx2 = 2: num_as_1
        if ((COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
            if(AS_LNK_TYPE(idx,1) == 1)
                num_link = num_link + 1;
            end
        end

    end
    PROVIDER_DEGREE(idx,:) = [COM_AS_UNQ(idx,1), num_link ];
end

%Graph 2.4
PROVIDER_DEGREE_BIN = zeros(1, 7);
PROVIDER_DEGREE_BIN =  bin_rank(PROVIDER_DEGREE_BIN ,PROVIDER_DEGREE,num_as_2);
PROVIDER_DEGREE_BIN
writematrix(PROVIDER_DEGREE,filename,'Sheet','PROVIDER_DEGREE','Range','B1')

writematrix(PROVIDER_DEGREE_BIN,filename,'Sheet','Rank_2','Range','B4');
%Generate the IP space assigned to each AS
IP_SP_BIN = zeros(1, 11);
for idx = 1: 974883
    if (RTV_PFX(idx,1) < 16)
        IP_SP_BIN(1,1) =  IP_SP_BIN(1,1) + 1;
    elseif ((RTV_PFX(idx,1) == 15))
        IP_SP_BIN(1,2) =  IP_SP_BIN(1,2) + 1;
    elseif ((RTV_PFX(idx,1) > 16) && (RTV_PFX(idx,1) < 18))
        IP_SP_BIN(1,3) =  IP_SP_BIN(1,3) + 1;
    elseif ((RTV_PFX(idx,1) > 17) && (RTV_PFX(idx,1) < 19))
        IP_SP_BIN(1,4) =  IP_SP_BIN(1,4) + 1;
    elseif ((RTV_PFX(idx,1) > 18) && (RTV_PFX(idx,1) < 20))
        IP_SP_BIN(1,5) =  IP_SP_BIN(1,5) + 1;
    elseif ((RTV_PFX(idx,1) > 19) && (RTV_PFX(idx,1) < 21))
        IP_SP_BIN(1,6) =  IP_SP_BIN(1,6) + 1;
    elseif ((RTV_PFX(idx,1) > 20) && (RTV_PFX(idx,1) < 22))
        IP_SP_BIN(1,7) =  IP_SP_BIN(1,7) + 1;
    elseif ((RTV_PFX(idx,1) > 21) && (RTV_PFX(idx,1) < 23))
        IP_SP_BIN(1,8) =  IP_SP_BIN(1,8) + 1;
    elseif ((RTV_PFX(idx,1) > 22) && (RTV_PFX(idx,1) < 24))
        IP_SP_BIN(1,9) =  IP_SP_BIN(1,9) + 1;
    elseif ((RTV_PFX(idx,1) > 23) && (RTV_PFX(idx,1) < 25))
        IP_SP_BIN(1,10) =  IP_SP_BIN(1,10) + 1;
    elseif ((RTV_PFX(idx,1) > 24))
        IP_SP_BIN(1,11) =  IP_SP_BIN(1,11) + 1;
    end
end
%Graph 3.0
IP_SP_BIN
writematrix(RTV_PFX ,filename,'Sheet','RTV_PFX','Range','B7');

% Graph 4.1 Find the AS without customers and peers
COM_AS_UNQ = unique(COM_AS_SRT);
num_as_2 = length(COM_AS_UNQ);
num_entrp = 0;
not_an_entr = 0;
for idx = 1 : num_as_2
    not_an_entr = 0;
    for idx1 = 1 : 463141
        %  if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx2, 1)) || (COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
        if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 1))
            not_an_entr = 1;
        elseif ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 0))
            not_an_entr = 1;
        end
    end
    if (not_an_entr == 0)
        num_entrp = num_entrp + 1;
    end
end

% Graph 4.2 Find the AS without customers and only peers
COM_AS_UNQ = unique(COM_AS_SRT);
num_as_2 = length(COM_AS_UNQ);
num_content = 0;
have_customer = 0;
have_peer = 0;
for idx = 1 : num_as_2
    have_customer = 0;
    have_peer = 0;
    for idx1 = 1 : 463141
        %  if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx2, 1)) || (COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
        if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 1))
            have_customer = 1;
        end
        if (((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 0)) || ((COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 0)))
            have_peer = 1;
        end
    end
    if ((have_customer == 0) && (have_peer == 1))
        num_content = num_content + 1;
    end
end


% Graph 4.3 Find the AS with customers
COM_AS_UNQ = unique(COM_AS_SRT);
num_as_2 = length(COM_AS_UNQ);
num_transit = 0;
have_customer = 0;
have_peer = 0;
for idx = 1 : num_as_2
    have_customer = 0;
    for idx1 = 1 : 463141
        %  if ((COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx2, 1)) || (COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx2, 1)))
        if ( (COM_AS_UNQ(idx,1) == PRO_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 1))
            have_customer = 1;
        end
    end
    if (have_customer == 1 )
        num_transit = num_transit + 1;
    end
end

num_transit
num_content
num_entrp
%writematrix(num_transit,filename,'Sheet','Rank_2','Range','B9');
%writematrix(num_content,filename,'Sheet','Rank_2','Range','B10');
%writematrix(num_entrp,filename,'Sheet','Rank_2','Range','B11');
%%Section 2.3
num_as_2 = length(COM_AS_UNQ);
PRO = zeros(num_as_2,2);

PRO = GLB_DEGREE;
temp_stg = zeros(1,2);
for idx = 1 : (num_as_2 -1)
    for idx1 = (idx + 1) : num_as_2
        if (PRO(idx,2) < PRO(idx1,2))
            temp_stg = PRO(idx,:);
            PRO(idx,:) = PRO(idx1,:);
            PRO(idx1,:) = temp_stg;
        end
    end
end
PRO;

%Remove 1,2,3,4,11,16, 19, 20
GLB_DEGREE_CORRECTED = zeros(num_as_2,2);
for idx = 1 : 6
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+4), :);
end

for idx = 7 : 10
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+5), :);
end

for idx = 11 : 12
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+6), :);
end


for idx = 13 : 13
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+8), :);
end

for idx = 14 : 14
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+11), :);
end

for idx = 15 : 17
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+12), :);
end

for idx = 18 : 19
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+13), :);
end

for idx = 20 : 25
    GLB_DEGREE_CORRECTED(idx,:) = PRO((idx+14), :);
end

%%RUN greedy algorithm
% Take the top 50 AS and check if they are interconnected
GLB_AS_TREE_SET = zeros(1,50);

AS1_top_deg_length =  PRO(1, 2);
%create a multidimentional array to hold all the AS numbers connected to
%firt 50 top degree AS's
LINK_DB = zeros(50,AS1_top_deg_length );
array_idx  = 1;
for idx = 1 : 50
    array_idx = 1;
    for idx1 = 1 : 463141
        if (GLB_DEGREE_CORRECTED(idx,1) == PRO_AS_NUM(idx1, 1)) % && (AS_LNK_TYPE(idx1,1) == 0)) || ((COM_AS_UNQ(idx,1) == CUS_AS_NUM(idx1, 1)) && (AS_LNK_TYPE(idx1,1) == 0)))
            LINK_DB(idx, array_idx) = CUS_AS_NUM(idx1, 1);
            array_idx = array_idx + 1;
        elseif (GLB_DEGREE_CORRECTED(idx,1) == CUS_AS_NUM(idx1, 1))
            LINK_DB(idx, array_idx) = PRO_AS_NUM(idx1, 1);
            array_idx = array_idx + 1;
        end
    end
    LINK_DB(idx, :);
end


%%Check given AS is present in the link AS list of previous ASes.
GLB_AS_TREE_SET(1,1) = PRO(4,1);
array_idx = 1;
count_det = 0;
counter = 0;
for idx = 2 : 50
    array_idx = 1;
    count_det = 0;
    counter = 0;
    for idx1 = 1 : idx-1
        array_idx = 1;
        count_det = 0;
        %if (count_det > idx1) fprintf("Error in AS detection: Duplicate found  idx is %d and idx1 is %d\n", idx, idx1); end
        while (LINK_DB(idx, array_idx) ~= 0)
            if (GLB_DEGREE_CORRECTED(idx, 1) == LINK_DB(idx1, array_idx))
                count_det =  1;
                %   fprintf("Error in AS detection: Duplicate found  idx is %d and idx1 is %d, GLB AS is %d and det is %d, \n", idx, idx1, GLB_DEGREE_SORT(idx, 1),LINK_DB(idx1, array_idx));
            end
            array_idx = array_idx + 1;
        end
        if (count_det == 1) counter = counter + 1; % fprintf(" counter is %d \n", counter) ;
        end
    end
    %if (count_det == 1) counter = counter + 1;  fprintf(" counter is %d \n", counter) ; end
    if ((counter + 1) == idx ) GLB_AS_TREE_SET(1, (idx )) = GLB_DEGREE_CORRECTED(idx,1); end
end

GLB_AS_TREE_SET
writematrix(GLB_AS_TREE_SET,filename,'Sheet','Rank_2','Range','B18');


%%2.4
PRO_AS_UNIQ = unique(PRO_AS_NUM);
PRO_AS_UNIQ;

num_unq_pro_as = length(PRO_AS_UNIQ);
num_unq_pro_as;
PRO_AS_UNIQ_RANK = zeros(num_unq_pro_as, 3);
PRO_AS_UNIQ_RANK_SORT = zeros(num_unq_pro_as, 3);
pro_as_rank = 0;
num_ip = 0;
for idx = 1 : num_unq_pro_as
    pro_as_rank = 0;
    num_ip = 0;
    for idx1 = 1 : 463141
        //if((PRO_AS_UNIQ(idx, 1) == PRO_AS_NUM(idx1,1)) && (AS_LNK_TYPE(idx1, 1) == 1))
            pro_as_rank = pro_as_rank + 1;
            for idx2 = 1: 974883
                if(RTV_AS(idx2,1) == PRO_AS_UNIQ(idx, 1) )
                    if(RTV_PFX(idx2,1) == 24)
                        num_ip = 255 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 23)
                        num_ip = 512 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 22)
                        num_ip = 1024 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 21)
                        num_ip = 2048 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 20)
                        num_ip = 4096 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 19)
                        num_ip = 8192 + num_ip;
                    elseif (RTV_PFX(idx2,1) == 18)
                        num_ip = 16384  + num_ip;
                        %elseif (RTV_PFX(idx2,1) == 18)
                        %      num_ip = (RTV_PFX(idx2,1)*32768 ) + num_ip;
                        %//   elseif (RTV_PFX(idx2,1) == 17)
                        %//       num_ip =   (RTV_PFX(idx2,1)*65000 ) + num_ip;
                    end
                end
            end

        end
    end
    PRO_AS_UNIQ_RANK(idx, :) = [PRO_AS_UNIQ(idx, 1), pro_as_rank, num_ip];
end
temp_stg = zeros(1,3);

PRO_AS_UNIQ_RANK_SORT = PRO_AS_UNIQ_RANK;

for idx = 1 : num_unq_pro_as
    for idx1 = (idx + 1) : num_unq_pro_as
        if (PRO_AS_UNIQ_RANK_SORT(idx,2) < PRO_AS_UNIQ_RANK_SORT(idx1,2))
            temp_stg = PRO_AS_UNIQ_RANK_SORT(idx,:);
            PRO_AS_UNIQ_RANK_SORT(idx,:) = PRO_AS_UNIQ_RANK_SORT(idx1,:);
            PRO_AS_UNIQ_RANK_SORT(idx1,:) = temp_stg;
        end
    end
end
writematrix(PRO_AS_UNIQ_RANK_SORT,filename,'Sheet','Rank_3','Range','A1');











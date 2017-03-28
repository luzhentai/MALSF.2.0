function LocalWeightAtlasPhi = LocalWeightFun_Rank( Atlas, Weight, SN)
%SN: select Atlas number


[Sx, Sy, Sz, St] = size(Atlas);
LocalWeightAtlasPhi = zeros(Sx, Sy, Sz, SN);

for x = 1:Sx
    for y = 1:Sy
        for z = 1:Sz
            A = Atlas(x, y, z, :);
            W = Weight(x, y, z, :);
            [SortW, index] = sort(W, 'descend');
            Rank = sort(1:length(W),  'descend');
            %NewW = Rank(1:SN) ;
            NewW = Rank(1:SN) / sum(Rank(1:SN));
            for m = 1 : SN
                
                LocalWeightAtlasPhi(x, y, z, m)  =  Atlas(x, y, z, index(m)) * NewW(m);
                
            end
        end
    end
end

classdef GoldCodeGenerator <handle
   
    properties
        seed;
        polynomial;
        stepsTable;
        stepsNum = 0;
        mlsrs;
    end    
    properties (Constant)
            
    end
    methods
        function obj=GoldCodeGenerator(seed, polynomial)
            obj.seed = seed;
            obj.polynomial = polynomial;
            obj.mlsrs = (2^length(obj.seed)) - 2;
        end
        
        function doUntilNewSeed(obj)
            obj.stepsTable{1} = obj.seed;
            obj.stepsNum = obj.stepsNum + 2;
            for i = 1:obj.mlsrs
                shiftRegister(obj, obj.stepsTable{i});
            end
        end
        
        function goldCode=getGoldCode(obj)
            doUntilNewSeed(obj);
            len = (obj.mlsrs+1);
            goldCode = zeros(len,1);
            for i = 1:len
                a = obj.stepsTable{i}(length(obj.seed));
                goldCode(i) = obj.stepsTable{i}(length(obj.seed));
            end
        end
        
        
        function shiftRegister(obj, previousStep)
            shifted = zeros(length(obj.seed),1);
            for i = 2:length(previousStep)
                shifted(i) = previousStep(i-1); 
            end
            shifted(1) = xor(previousStep(3), previousStep(5));
            obj.stepsTable{obj.stepsNum} = shifted;
            obj.stepsNum = obj.stepsNum + 1;
        end
    end
end
classdef OvsfTree <handle
   properties
       OvsfT ={};
   end
   methods
        function generateOvsfTree(obj, SF)
            obj.OvsfT{1,1} = [1]; 
            i = 2;
            while i <= SF
                generateBranches(obj, i)
                i = i*2;
            end
        end
        function code=getCode(obj, SF, numOfCode)
            code=obj.OvsfT{SF, numOfCode};
        end
   end
   methods(Access = private)
        function generateBranches(obj, lvlOfTree)
            for i = 1:lvlOfTree/2
                code = obj.OvsfT{lvlOfTree/2,i};
                generateNewBranchesFromCode(obj, code, i);
            end
        end
            
        function generateNewBranchesFromCode(obj, code, codeNum)
            numOfFirstNewCode = codeNum*2-1;
            obj.OvsfT{length(code)*2,numOfFirstNewCode} = [code code];
            obj.OvsfT{length(code)*2,numOfFirstNewCode+1} = [code -code];
        end
   end
end
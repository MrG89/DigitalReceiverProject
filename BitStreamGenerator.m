classdef BitStreamGenerator < handle
    methods
        function bitstream=generateBits(obj, howManyBits)
            bitstream = randi(2,howManyBits,1)-1;
        end
    end
end

classdef Transmitter < handle
    
    properties
        orgBitstream;
        bit_minusOne_one;
        bitStAfterSpreading;
        bitStAfterGoldcode;
        symStream;
        timeIndex = 0;
        omega = 0;
        numbOfSymb = 0;
        ovsfCode = 0;
        goldCode = 0;
    end
    
    properties(Constant)
        fc = 6;           %freq of carrier
        Ac = 1;             %carrier amplitude
        fs = 18;           %sampling frequency
        bitPerSymbol = 2;   %QPSK modulation
        symLength = 20;     %lenght of symbol
        coeff = [ pi/4 3*pi/4 5*pi/4 7*pi/4 ];  %phase coeff
        symbols = [0 0; 0 1; 1 0; 1 1];
    end
    
    methods
        function obj = Transmitter(bitstream, code)
            obj.omega = 2*pi*obj.fc;
            obj.orgBitstream = bitstream;
            obj.ovsfCode = code;          
        end
        
        function run(obj)
            spreadSignal(obj);
            %gold = GoldCodeGenerator([0 0 0 0 1]);
            %obj.goldCode = getGoldCode(gold);
            %todo rest
        end
        
        function signal = qpskSig(obj)
            generateSymbols(obj);
            signal=[];
            for sym = obj.symStream
                signal = [signal qpskModulation(obj,sym)];
            end
            t = (0:length(signal)-1)*1/obj.fs;
            plot(t,signal);
        end
        
        function oneSymbolSignal = qpskModulation(obj, symbol)
            t = calculateTime(obj);
            oneSymbolSignal = obj.Ac*cos((obj.omega*t)+obj.coeff(symbol));
            plot(t, oneSymbolSignal);
        end
        
    end
    
    methods (Access = private)
        function spreadSignal(obj)
            sizeOfCode = length(obj.ovsfCode);
            sizeOfBitstream = length(obj.orgBitstream);
            
            encoded = 2*obj.orgBitstream-ones(sizeOfBitstream,1);
            obj.bitStAfterSpreading = zeros(sizeOfBitstream*sizeOfCode); 
            for i = 1:sizeOfBitstream
                for j = 1:sizeOfCode
                    index = ((i-1)*sizeOfCode)+j;
                    obj.bitStAfterSpreading(index) = encoded(i)*obj.ovsfCode(j);
                end
            end
            obj.bit_minusOne_one = encoded;
        end
        
        function convertBitstreamToSymbols(obj)
            temp = [];
            i = 1;
            if(mod(length(obj.bitstream), obj.bitPerSymbol) == 0)
                while i <= length(obj.bitstream)
                    temp = [temp obj.bitstream(i)]
                    if(mod(length(temp), obj.bitPerSymbol) == 0)
                        detectSymbol(obj, temp);
                        temp = [];
                    end
                    i = i + 1;
                end
            else
                print('wrong size of bitstream');
            end
        end
        
        function detectSymbol(obj, bits)
            for i = 1:length(obj.symbols)
                if(isequal(bits, obj.symbols(i,:)))
                    obj.symStream = [obj.symStream i]
                    obj.numbOfSymb = obj.numbOfSymb + 1;
                    return;
                end
            end
            print('symbol not found')
        end
        
        function t=calculateTime(obj)
            t = (obj.timeIndex*obj.symLength:1/obj.fs:((obj.timeIndex+1)*obj.symLength)-1);
            obj.timeIndex = obj.timeIndex+1;
        end
        
    end
end
%clear all

SF = 16;
codeNum = 2;
numOfBits = 8;

bitsGen = BitStreamGenerator;
ovsf = OvsfTree;
generateOvsfTree(ovsf, SF);

bitstream = generateBits(bitsGen, numOfBits);
code = getCode(ovsf, SF, codeNum);

trans = Transmitter(bitstream, code);
run(trans);

subplot(5,1,1);
stem(rectpulse(bitstream,1));
axis([1 length(bitstream) 0 1]);
title('Generated bits');
xlabel('number of bit');
ylabel('state');

subplot(5,1,2);
stem(rectpulse(trans.bit_minusOne_one,1));
axis([1 length(trans.bit_minusOne_one) -1 1]);
title('Bit change to -1 1 state');
xlabel('number of bit');
ylabel('state');

subplot(5,1,3);
stem(rectpulse(code,1));
axis([1 length(code) -1 1]);
title('spreading code');
xlabel('number of bit');
ylabel('state');


subplot(5,1,4);
stem(rectpulse(trans.bitStAfterSpreading, 1))
title('Bits after spreading');
xlabel('number of bit');
ylabel('state');

%subplot(5,1,5);
%stem(rectpulse(trans.goldCode, 1))
%title('GoldCode');
%xlabel('number of bit');
%ylabel('state');


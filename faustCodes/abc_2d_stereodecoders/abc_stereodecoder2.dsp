//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------FAUST CODE AND UTILITIES FOR MIXED MUSIC---------------------//
//
//----------------------------- BY ALAIN BONARDI - 2019-2021 ---------------------------//
//---------------------CICM - MUSIDANSE LABORATORY - PARIS 8 UNIVERSITY-----------------//
//--------------------------------------------------------------------------------------//
//
declare author "Alain Bonardi";
declare licence "LGPLv3";
declare name "abc_stereodecoder2";
//
import("stdfaust.lib");
//
//uses abcdbcontrol.dsp
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS: POSITIONS OF THE LOUDSPEAKERS IN DEGREES (anticlockwise)
//--------------------------------------------------------------------------------------//
gain = hslider("v:stereodecoder/gain [unit:dB]", 0, -127, 18, 0.01) : dbtogain;
direct = 2 * checkbox("v:stereodecoder/directangles") - 1; 
//--------------------------------------------------------------------------------------//
// GAIN LINES IN PARALLEL
//--------------------------------------------------------------------------------------//
gainLine(n) = par(i, n, *(gain));
//--------------------------------------------------------------------------------------//
//A VECTOR OF GAINS ON THE OUTPUT
//--------------------------------------------------------------------------------------//
leftDispatcher = _<:(*(1-direct), *(direct));
rightDispatcher = _<:(*(direct), *(1-direct));
//--------------------------------------------------------------------------------------//
//AMBISONIC DECODING IN STEREO WITH IRREGULAR ORDER
//-------------------------------------------------------------------
mystereodecoder(n)	= ho.decoderStereo(n) : gainLine(2) : (leftDispatcher, rightDispatcher) :> (_, _);
//
//--------------------------------------------------------------------------------------//
// CONVERSION DB=>LINEAR
//--------------------------------------------------------------------------------------//
dbcontrol = _ <: ((_ > -127.0), ba.db2linear) : *;
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETER: GAIN IN DB
//--------------------------------------------------------------------------------------//
dbtogain = si.smoo : dbcontrol;
//
//
process = mystereodecoder(2);

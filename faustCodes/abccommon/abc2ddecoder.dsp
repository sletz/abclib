//
//--------------------------------------------------------------------------------------//
//AMBISONIC DECODERS
//--------------------------------------------------------------------------------------//
//
import("stdfaust.lib");
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS
//--------------------------------------------------------------------------------------//
//
direct = 2 * checkbox("v:decoder/directangles") - 1; 
offset = hslider("v:decoder/angularoffset [unit:deg]", 0, -180, 180, 1) * ma.PI / 180;
gain = hslider("v:decoder/gain [unit:dB]", 0, -127, 18, 0.01) : dbtogain;
a(ind, nls) = (hslider("v:decoder/a%2ind [unit:deg]", ind * 360 / nls, -360, 360, 1) * ma.PI / 180. - direct * offset) : *(direct) : si.smoo;
stereo = checkbox("v:decoder/stereo") : si.smoo;
ambisonic = 1 - stereo;
//--------------------------------------------------------------------------------------//
// GAIN LINES IN PARALLEL
//--------------------------------------------------------------------------------------//
gainLine(n) = par(i, n, *(gain));
//--------------------------------------------------------------------------------------//
//AMBISONIC DECODING WITH IRREGULAR ORDER
//-------------------------------------------------------------------
myambisonicdecoder(n, p)	= par(i, 2*n+1, _) <: par(i, p, speaker(n, a(i,p)))
with 
{
   speaker(n,alpha)	= /(2), par(i, 2*n, _), ho.encoder(n,2/(2*n+1),alpha) : si.dot(2*n+1);
};
//--------------------------------------------------------------------------------------//
//A VECTOR OF GAINS ON THE OUTPUT
//--------------------------------------------------------------------------------------//
leftDispatcher = _<:(*(1-direct), *(direct));
rightDispatcher = _<:(*(direct), *(1-direct));
//
//--------------------------------------------------------------------------------------//
//AMBISONIC DECODING IN STEREO WITH IRREGULAR ORDER
//--------------------------------------------------------------------------------------//
mystereodecoder(n, p) = ((ho.decoderStereo(n) : (leftDispatcher, rightDispatcher) :> (_, _)), (0 <: si.bus(p-2)));
//
//--------------------------------------------------------------------------------------//
//INPUT DISPATCHING
//--------------------------------------------------------------------------------------//
//starting with n values A1, A2,...An, we want to get A1, A2, ..., An, A1, A2,..., An
//--------------------------------------------------------------------------------------//
inputDispatch(n) = si.bus(n) <: (si.bus(n), si.bus(n));
//
//--------------------------------------------------------------------------------------//
//A GENERAL DECODER ENABLING AMBISONIC IRREGULAR ORDER (ambisonic = 1) OR STEREO (ambisonic = 0)
//--------------------------------------------------------------------------------------//
mydecoder(n, p) = inputDispatch(2*n+1) : (myambisonicdecoder(n, p), mystereodecoder(n, p)) : (par(i, p, *(ambisonic)), *(stereo), *(stereo), si.bus(p-2))  :> si.bus(p) : gainLine(p);
//
//
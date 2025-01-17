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
declare name "abc_2d_encoder1";
//
//--------------------------------------------------------------------------------------//
//AMBISONIC ENCODERS
//--------------------------------------------------------------------------------------//
//
import("stdfaust.lib");
//
//uses abcencodingrotation.dsp
//
//--------------------------------------------------------------------------------------//
//CONTROL PARAMETERS
//--------------------------------------------------------------------------------------//
//
rotfreq = hslider("v:encoder/speed [unit:s-1]", 0, -100, 100, 0.001);
rotphase = hslider("v:encoder/angle [unit:deg]", 0, -360, 360, 0.01) / 360;
returntime = hslider("v:encoder/returntime [unit:msec]", 20, 0, 1000, 1) * 0.001;
//
//--------------------------------------------------------------------------------------//
//SELECTING AN ENCODER FROM HO FAUST LIBRARY
//--------------------------------------------------------------------------------------//
myEncoder(sig, angle) = ho.encoder(ao, sig, angle);//at ambisonic order ao.             //
//
//--------------------------------------------------------------------------------------//
//SENDING THE PHASED ANGLE FUNCTION TO THE ENCODER
//--------------------------------------------------------------------------------------//
freqPhaseEncoder(f, p, dt) = (_, rotationOrStaticAngle(f, p, dt)) : myEncoder;
//
//--------------------------------------------------------------------------------------//
//STATIC OR ROTATION PHASE BETWEEN 0 AND 1
//--------------------------------------------------------------------------------------//
rotationOrStaticPhase(f, p, dt) = (1-vn) * x + vn * p
with {
		vn = (f == 0) : si.smooth(ba.tau2pole(dt));
		//to manage the case where frequency is zero, smoothly switches from one mode to another//
		x = (os.phasor(1, f), p, 1) : (+, _) : fmod;
};
//
//--------------------------------------------------------------------------------------//
//PHASE TO RADIAN ANGLE CONVERSION
//--------------------------------------------------------------------------------------//
rotationOrStaticAngle(f, p, dt) = rotationOrStaticPhase(f, p, dt) * 2 * ma.PI;
//
ao = 1;//ambisonic order//
process = freqPhaseEncoder(rotfreq, rotphase, returntime);

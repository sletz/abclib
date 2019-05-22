//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------------FAUST CODE FOR MIXED MUSIC-----------------------------//
//
//-------------------------------- BY ALAIN BONARDI - 2019 -----------------------------//
//--------------------------------------------------------------------------------------//

declare name "abc2Ddecoder2_6";
declare author "Alain Bonardi";
declare licence "GPLv3";

import("stdfaust.lib");
import("../abccommon/abc2ddecoder.dsp");

//--------------------------------------------------------------------------------------//
//HOA DECODER AT ORDER AO TO NL LOUDSPEAKERS//
//--------------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------------//
//AMBISONIC ORDER AND NUMBER OF LOUDSPEAKERS
//--------------------------------------------------------------------------------------//
ao = 2;
nl = 6;

//--------------------------------------------------------------------------------------//
//DECODING
//--------------------------------------------------------------------------------------//
process = mydecoder(ao, nl);
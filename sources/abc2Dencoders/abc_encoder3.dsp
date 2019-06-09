//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------------FAUST CODE FOR MIXED MUSIC-----------------------------//
//
//-------------------------------- BY ALAIN BONARDI - 2019 -----------------------------//
//--------------------------------------------------------------------------------------//

declare name "abc2Dencoder3";
declare author "Alain Bonardi";
declare licence "GPLv3";

import("stdfaust.lib");
import("../abccommon/abc2dencoder.dsp");

//--------------------------------------------------------------------------------------//
//HOA ENCODER//
//--------------------------------------------------------------------------------------//
ao = 3; //ambisonic order is 3//


//--------------------------------------------------------------------------------------//
//PROCESS FUNCTION
//--------------------------------------------------------------------------------------//
process = freqPhaseEncoder(rotfreq, rotphase, returntime);
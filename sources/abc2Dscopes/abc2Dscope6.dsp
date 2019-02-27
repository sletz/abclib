//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------------FAUST CODE FOR MIXED MUSIC-----------------------------//
//
//-------------------------------- BY ALAIN BONARDI - 2019 -----------------------------//
//--------------------------------------------------------------------------------------//

declare name "abc2Dscope6";
declare author "Alain Bonardi";
declare licence "GPLv3";

import("stdfaust.lib");
import("abcd2dscope.dsp");

//--------------------------------------------------------------------------------------//
//AMBISONIC ORDER TO BE MODIFIED
//--------------------------------------------------------------------------------------//
n = 6;//ambisonic order 6 here//

process = (rho <: (_, _) : (*(sin(theta)), *(cos(theta))) : (*(-1), _));
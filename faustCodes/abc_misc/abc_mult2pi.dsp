//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------FAUST CODE AND UTILITIES FOR MIXED MUSIC---------------------//
//
//----------------------------- BY ALAIN BONARDI - 2019-2020 ---------------------------//
//---------------------CICM - MUSIDANSE LABORATORY - PARIS 8 UNIVERSITY-----------------//
//--------------------------------------------------------------------------------------//
//
declare author "Alain Bonardi";
declare licence "GPLv3";
declare name "abc_mult2pi";
//
import("stdfaust.lib");
//
//--------------------------------------------------------------------------------------//
//MULTIPLICATION BY 2*PI
//--------------------------------------------------------------------------------------//
mult2pi = *(2. * ma.PI);
//
process = mult2pi;
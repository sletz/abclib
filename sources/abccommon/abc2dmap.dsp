//--------------------------------------------------------------------------------------//
//----------------------------------------abclib----------------------------------------//
//
//-------------------------------FAUST CODE FOR MIXED MUSIC-----------------------------//
//
//-------------------------------- BY ALAIN BONARDI - 2019 -----------------------------//
//--------------------------------------------------------------------------------------//

//----------------------------------ABC 2D POLAR MAPS-----------------------------------//

//polar coordinates//
//the angle is a phase between 0 and 1//

myMap(sig, r, a) = ho.map(ao, sig, r, a * 2. * ma.PI);
#include <iostream>
#include <iomanip>
#include <cmath>

// ******* define measured values here
// ******* for better accuracy all values should be measured multiple times

//xy

//const double AC_values[] = {141.155, 141.14, 141.15};
//const double BD_values[] = {141.35, 141.3, 141.325};
//const double AD_values[] = {99.855, 99.855, 99.825};

//xz

//const double AC_values[] = {113.175, 113.140, 113.19, 113.165};
//const double BD_values[] = {112.275, 112.3, 112.32, 112.3};
//const double AD_values[] = {79.975,79.975,79.970,79.995};

//yz
const double AC_values[] = {112.525, 112.55, 112.52, 112.525};
const double BD_values[] = {112.85, 112.84, 112.85, 112.82, 112.885 };
const double AD_values[] = {79.945, 79.925, 79.92, 79.915};

// *******
// *******

template <typename T, int N>
constexpr int ConstArraySize (T (&target)[N]) { return sizeof(target)/sizeof(target[0]); }

template <typename T, int N>
constexpr T ConstAverage (T (&target)[N])
{
  int arraySize=ConstArraySize(target);
  auto average=target[0];
  for(int i=1; i<arraySize; ++i)
    average+=(target[i]-average)/(T)(i+1);
  return average;
}

const double AC=ConstAverage(AC_values);
const double BD=ConstAverage(BD_values);
const double AD=ConstAverage(AD_values);

int main(void)
{
  auto AB=sqrt(2.0*AC*AC+2.0*BD*BD-4.0*AD*AD)/2.0;
  auto skewFactor=tan(M_PI_2-acos((AC*AC-AB*AB-AD*AD)/(2.0*AB*AD)));
  std::cout << "Skew factor = " << std::setprecision (32) << skewFactor << std::endl;
  return 0;
}

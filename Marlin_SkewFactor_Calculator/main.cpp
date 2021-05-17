#include <iostream>
#include <iomanip>
#include <cmath>

// ******* define measured values here
// ******* for better accuracy all values should be measured multiple times

//xy

//const double AC_values[] = {141.18, 141.18, 141.18, 141.18};
//const double BD_values[] = {140.95, 140.96, 140.96, 140.96};
//const double AD_values[] = {100.02, 100.02, 100.02, 100.02};

//xz

//const double AC_values[] = {112.95, 112.96, 112.96, 112.95};
//const double BD_values[] = {112.92, 112.93, 112.93, 112.92};
//const double AD_values[] = {79.82, 79.84, 79.85, 79.82};

//yz
const double AC_values[] = {112.72, 112.74, 112.72, 112.75};
const double BD_values[] = {112.94, 112.94, 112.86, 112.88};
const double AD_values[] = {79.92, 79.86, 79.88, 79.88};

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

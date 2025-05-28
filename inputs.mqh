//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __INPUTS_MQH__
#define __INPUTS_MQH__

input string _Settings0 = "<===== Visualization =====>"; // SETTINGS
input  bool ShowPointOffset_Label = true;
input  bool ShowTimeDiff_Label = true;
input string _Settings1 = "<===== Lables Settings =====>"; // SETTINGS
input int PointOffset = 100;
input int FontSize = 8;
input color LabelColor = clrBlack;
input string _Settings2 = "<===== Fibo Settings =====>"; // SETTINGS
input  color fibColor = clrBlack;  // Fibo Color
input color fibCenterColor = clrGray;  // CenterLine Color
input ENUM_LINE_STYLE fibStyle = STYLE_DASHDOTDOT;  // Line style
input int fibWidth = 1; //fibo width


#endif

//+------------------------------------------------------------------+

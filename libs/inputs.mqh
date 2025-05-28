//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __INPUTS_MQH__
#define __INPUTS_MQH__

#include "candleTimer/types.candleTimer.mqh"

input string _Settings0 = "<===== Visualization =====>"; // SETTINGS
input  bool ShowComment = true;
input  bool ShowCandleTimer = true;
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
input string _Settings3 = "<===== Timer Settings =====>"; // SETTINGS
input CCTR_LOCATION   cctrLocation          = CCTR_BOTTOM_LEFT;        // Lable Location
input CCTR_ONOFF  cctrDisplayServerTime = CCTR_ON;        // Display Server Time
input CCTR_ONOFF  cctrPlayAlert         = CCTR_OFF;       // Sound alert when the candle is closed
input string cctrCustomAlertSound  = "";        // Custom alert sound
input int    cctrFontSize          = 9;         // Font Size
input color  cctrColor            = clrBlack; // Color


#endif

//+------------------------------------------------------------------+

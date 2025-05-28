//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __GLOBALS_MQH__
#define __GLOBALS_MQH__

#include "candleTimer/candleTimer.mqh"

CCTRLib* g_cctr;
double g_point;
ulong g_currentTickCount;
ulong g_lastPrint2s = 0;
bool g_isExtendEnable = false;

#endif
//+------------------------------------------------------------------+

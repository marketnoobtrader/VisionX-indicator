//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TYPES_MQH__
#define __TYPES_MQH__

struct FiboLevel
   {
    double           PriceLevel;
    color            LineColor;
    ENUM_LINE_STYLE  LineStyle;
    int              LineWidth;
    string           LabelText;
   };

enum FiboMode
   {
    FIBO_MODE_RR = 2,
    FIBO_MODE_THIRDS = 3,
    FIBO_MODE_QUARTERS = 4,
   };

#endif
//+------------------------------------------------------------------+

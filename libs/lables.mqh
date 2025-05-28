//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "inputs.mqh"
#include "constants.mqh"
#include "tools.mqh"
#include "globals.mqh"

int _baseX, _baseY, _shiftedX, _shiftedY, _offsetX, _offsetY;
const string _pointLableSeperator = "----";
const string _pointLableTXT = string(PointOffset) + " points ";
const string _pointLableSeperatorArrow = ">";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setPointLable()
   {
    if(!ShowPointOffset_Label)
        return;
// Convert chart time/price to screen coordinates
    ChartTimePriceToXY(0, 0, Time[1], High[1], _baseX, _baseY);
    ChartTimePriceToXY(0, 0, Time[1], High[1] + (PointOffset * Point), _shiftedX, _shiftedY);
    _offsetX = MathAbs(_shiftedX - _baseX);
    _offsetY = MathAbs(_shiftedY - _baseY);
    LabelCreate(0, GenerateRandomObjectName(g_DYNAMIC_DEFAULT_STRING), 0, 0,
                70,
                CORNER_RIGHT_UPPER, _pointLableTXT, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
    LabelCreate(0, GenerateRandomObjectName(g_DYNAMIC_DEFAULT_STRING), 0, 0, 70, CORNER_RIGHT_UPPER, _pointLableSeperator, FontSize, LabelColor, 0, ANCHOR_RIGHT);
    LabelCreate(0, GenerateRandomObjectName(g_DYNAMIC_DEFAULT_STRING), 0, 0, 70 + _offsetY, CORNER_RIGHT_UPPER, _pointLableSeperator, FontSize, LabelColor, 0, ANCHOR_RIGHT);
    LabelCreate(0, GenerateRandomObjectName(g_DYNAMIC_DEFAULT_STRING), 0, 0, 70 + 1, CORNER_RIGHT_UPPER, _pointLableSeperatorArrow, FontSize, LabelColor, 90, ANCHOR_RIGHT_LOWER);
    LabelCreate(0, GenerateRandomObjectName(g_DYNAMIC_DEFAULT_STRING), 0, 0, 70 + _offsetY - 1, CORNER_RIGHT_UPPER, _pointLableSeperatorArrow, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setTimeLable()
   {
    if(!ShowTimeDiff_Label)
        return;
// Calculate broker time offset
    int brokerOffsetMinutes = GetBrokerTimeOffsetMinutes();
    string brokerOffsetString = TimeOffsetToString(brokerOffsetMinutes);
    string timeOffsetLabel = "[Time Difference]: " + brokerOffsetString;
    LabelCreate(0, GenerateRandomObjectName(g_STATIC_DEFAULT_STRING), 0, 0, 7, CORNER_RIGHT_LOWER, timeOffsetLabel, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setAllLables()
   {
    setPointLable();
    setTimeLable();
// WindowRedraw();
   }
//+------------------------------------------------------------------+

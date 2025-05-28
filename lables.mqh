//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "inputs.mqh"
#include "constants.mqh"
#include "tools.mqh"
#include "globals.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setPointLable()
   {
    if(!ShowPointOffset_Label)
        return;
// Convert chart time/price to screen coordinates
    int baseX, baseY, shiftedX, shiftedY, offsetX, offsetY;
    ChartTimePriceToXY(0, 0, Time[1], High[1], baseX, baseY);
    ChartTimePriceToXY(0, 0, Time[1], High[1] + (PointOffset * Point), shiftedX, shiftedY);
    offsetX = MathAbs(shiftedX - baseX);
    offsetY = MathAbs(shiftedY - baseY);
    LabelCreate(0, GenerateRandomObjectName(DYNAMIC_DEFAULT_STRING), 0, 0,
                70,
                CORNER_RIGHT_UPPER, pointLableTXT, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
    LabelCreate(0, GenerateRandomObjectName(DYNAMIC_DEFAULT_STRING), 0, 0, 70, CORNER_RIGHT_UPPER, pointLableSeperator, FontSize, LabelColor, 0, ANCHOR_RIGHT);
    LabelCreate(0, GenerateRandomObjectName(DYNAMIC_DEFAULT_STRING), 0, 0, 70 + offsetY, CORNER_RIGHT_UPPER, pointLableSeperator, FontSize, LabelColor, 0, ANCHOR_RIGHT);
    LabelCreate(0, GenerateRandomObjectName(DYNAMIC_DEFAULT_STRING), 0, 0, 70 + 1, CORNER_RIGHT_UPPER, pointLableSeperatorArrow, FontSize, LabelColor, 90, ANCHOR_RIGHT_LOWER);
    LabelCreate(0, GenerateRandomObjectName(DYNAMIC_DEFAULT_STRING), 0, 0, 70 + offsetY - 1, CORNER_RIGHT_UPPER, pointLableSeperatorArrow, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
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
    LabelCreate(0, GenerateRandomObjectName(STATIC_DEFAULT_STRING), 0, 0, 7, CORNER_RIGHT_LOWER, timeOffsetLabel, FontSize, LabelColor, -90, ANCHOR_RIGHT_UPPER);
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

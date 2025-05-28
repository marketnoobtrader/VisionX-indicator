//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "neo"
#property link "marketnoobtrader@gmail.com"
#property version "3.0"
#property description "[FREE]"
#property indicator_chart_window

#include "libs/inputs.mqh"
#include "libs/tools.mqh"

#include "libs/fibo/types.fibo.mqh"
#include "libs/constants.mqh"
#include "libs/globals.mqh"
#include "libs/fibo/fibo.mqh"
#include "libs/lables.mqh"
#include "libs/candleTimer/candleTimer.mqh"




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
   {
// ChartSetInteger(0, CHART_SHOW_BID_LINE, 0);
// ChartSetInteger(0, CHART_COLOR_ASK, clrLightGray);
// ChartSetInteger(0, CHART_COLOR_GRID, clrBlack);
// ChartSetInteger(0, CHART_SHOW_GRID, 0);
// ChartSetDouble(0, CHART_FIXED_POSITION, 35);
// ChartSetInteger(0, CHART_SHOW_ASK_LINE, 0);
    point = Point;
    if((Digits == 3) || (Digits == 5))
       {
        point *= 10;
       }
    MathSrand(GetTickCount());
    setAllLables();
    if(ShowCandleTimer)
       {
        cctr = new CCTRLib(cctrLocation, cctrDisplayServerTime, cctrPlayAlert, cctrCustomAlertSound, cctrFontSize, cctrColor);
        cctr.Init();
        EventSetMillisecondTimer(500);
       }
    else
       {
        EventSetMillisecondTimer(2000);
       }
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
   {
    currentTickCount = GetTickCount();
    if(cctr != NULL)
       {
        cctr.Update();
       }
// Every 2 seconds
    if(currentTickCount - lastPrint2s >= 2000)
       {
        lastPrint2s = currentTickCount;
        DeleteObject(DYNAMIC_DEFAULT_STRING);
        setPointLable();
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
   {
    if(cctr != NULL && IsVisualMode())
       {
        cctr.Update();
       }
    if(ShowComment)
       {
        comment();
       }
    return (rates_total);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
    DeleteObject(STATIC_DEFAULT_STRING);
    DeleteObject(DYNAMIC_DEFAULT_STRING);
    EventKillTimer();
    if(cctr != NULL)
       {
        delete cctr;
        cctr = NULL;
       }
    Comment("");
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment()
   {
    string depositCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    double tickSize = MarketInfo(NULL, MODE_TICKSIZE);
    double tickValue = MarketInfo(NULL, MODE_TICKVALUE);
    double pipValuePerLot = (tickValue * point) / tickSize;
    double pipValue = pipValuePerLot * 1; // lotSize>> 1
    string info = "\n";
    info += "#Spread: " + DoubleToStr(SPREAD, 1) + "\n";
    info += "#Pip Value(" + depositCurrency + "): " + DoubleToStr(pipValue, 2) + "\n";
    Comment(info);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
    if(id == CHARTEVENT_OBJECT_CLICK)
       {
        if(isExtendEnable)
           {
            double _price2 = ObjectGet(sparam, OBJPROP_PRICE2);
            double _price1 = ObjectGet(sparam, OBJPROP_PRICE1);
            color _color = (color)ObjectGet(sparam, OBJPROP_COLOR);
            int _width = (int)ObjectGet(sparam, OBJPROP_WIDTH);
            ENUM_LINE_STYLE _style = (ENUM_LINE_STYLE)ObjectGet(sparam, OBJPROP_STYLE);
            bool _fill = (int)ObjectGet(sparam, OBJPROP_BGCOLOR);
            bool _back = (int)ObjectGet(sparam, OBJPROP_BACK);
            datetime _time2 = (datetime)ObjectGet(sparam, OBJPROP_TIME2);
            datetime _time1 = (datetime)ObjectGet(sparam, OBJPROP_TIME1);
            datetime maxTime = (_time1 > _time2) ? _time1 : _time2;
            datetime minTime = (_time1 > _time2) ? _time2 : _time1;
            if(FindText(sparam, "Rectangle"))
               {
                ObjectDelete(sparam);
                RectangleCreate(0, sparam, 0, minTime, _price1, FindBarTimeByPriceRange(_price1, maxTime, _price2), _price2, _color, _style, _width, _fill, _back);
                // ObjectSet(sparam, OBJPROP_TIME2, FindBarTimeByPriceRange(_price1, maxTime, _price2));
               }
            if(FindText(sparam, "Trendline"))
               {
                ObjectDelete(sparam);
                TrendCreate(0, sparam, 0, minTime, _price1, FindBarTimeByPriceRange(_price1, maxTime), _price1, _color, _style, _width, _back);
               }
           }
       }
    if(id == CHARTEVENT_KEYDOWN)
       {
        short result = TranslateKey((int)lparam);
        string code = ShortToString(result);
        StringToUpper(code);
        if(code == "1")
           {
            isExtendEnable = !isExtendEnable;
           }
        else
            if(result == 9)
               {
                ChartGetInteger(0, CHART_SCALEFIX) ? ChartSetInteger(0, CHART_SCALEFIX, false) : ChartSetInteger(0, CHART_SCALEFIX, true);
               }
            else
                if(code == "4")
                   {
                    CreateFiboLevels(FIBO_MODE_QUARTERS, fiboLevelsQuarters);
                   }
                else
                    if(code == "3")
                       {
                        CreateFiboLevels(FIBO_MODE_THIRDS, fiboLevelsThirds);
                       }
                    else
                        if(code == "2")
                           {
                            CreateFiboLevels(FIBO_MODE_RR, fiboLevelsRR);
                           }
                        else
                            if(code == "0")
                               {
                                DeleteAllObject();
                               }
                            else
                                if(code == "Q" || result == 1590)
                                   {
                                    obj_set_width(1);
                                   }
                                else
                                    if(code == "W" || result == 1589)
                                       {
                                        obj_set_width(2);
                                       }
                                    else
                                        if(code == "E" || result == 1579)
                                           {
                                            obj_set_width(4);
                                           }
                                        else
                                            if(code == "R" || result == 1602)
                                               {
                                                obj_set_color(clrRed);
                                               }
                                            else
                                                if(code == "T" || result == 1602)
                                                   {
                                                    obj_set_color(clrTeal);
                                                   }
                                                else
                                                    if(code == "Y" || result == 1594)
                                                       {
                                                        obj_set_color(clrYellow);
                                                       }
                                                    else
                                                        if(code == "B" || result == 1584)
                                                           {
                                                            obj_set_color(clrBlue);
                                                           }
                                                        else
                                                            if(code == "L" || result == 1584)
                                                               {
                                                                obj_set_color(clrMediumTurquoise);
                                                               }
                                                            else
                                                                if(code == "O" || result == 1582)
                                                                   {
                                                                    obj_set_color(clrOlive);
                                                                   }
                                                                else
                                                                    if(code == "G" || result == 1604)
                                                                       {
                                                                        obj_set_color(clrGray);
                                                                       }
                                                                    else
                                                                        if(code == "P" || result == 1581)
                                                                           {
                                                                            obj_set_color(clrPlum);
                                                                           }
                                                                        else
                                                                            if(result == 96 || result == 247)
                                                                               {
                                                                                string obj_selected[];
                                                                                ArrayResize(obj_selected, 0);
                                                                                SelectedObj(obj_selected);
                                                                                for(int i = 0; i < ArraySize(obj_selected); i++)
                                                                                   {
                                                                                    if(obj_selected[i] != NULL)
                                                                                       {
                                                                                        // Print(ObjectGet(obj_selected[i],OBJPROP_FILL));
                                                                                        if(!ObjectGet(obj_selected[i], OBJPROP_FILL))
                                                                                           {
                                                                                            ObjectSet(obj_selected[i], OBJPROP_FILL, 1);
                                                                                           }
                                                                                        else
                                                                                           {
                                                                                            ObjectSet(obj_selected[i], OBJPROP_FILL, 0);
                                                                                           }
                                                                                        ObjectSet(obj_selected[i], OBJPROP_BACK, 1);
                                                                                       }
                                                                                   }
                                                                               }
       }
   }

//+------------------------------------------------------------------+

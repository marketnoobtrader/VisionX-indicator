//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+


#define SPREAD    (Ask - Bid) / Point
#define NL        "\n"
#define WinMid    WindowFirstVisibleBar() - ((int)WindowBarsPerChart() / 2)
#define MiddlePrice ND(WindowPriceMax() - (WindowPriceMax() - WindowPriceMin()) / 2)
//#define PipValue  ND(double((MarketInfo(Symbol(),MODE_TICKVALUE)*100)))
//#define PipValue  ND(double((MarketInfo(Symbol(),MODE_TICKVALUE))/MarketInfo(Symbol(),MODE_TICKSIZE)))


//string last_boject = "";
//ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, true);
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
//   {
//    if(id == CHARTEVENT_OBJECT_DELETE)
//       {
//        last_boject=sparam;
//       }
//   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//datetime DateTradeDay(datetime dt)
//   {
//    int ty = TimeYear(dt);
//    int tm = TimeMonth(dt);
//    int td = TimeDay(dt);
//    int th = TimeHour(dt);
//    int ti = TimeMinute(dt);
//    td--;
//    if(td == 0)
//       {
//        tm--;
//        if(tm == 0)
//           {
//            ty--;
//            tm = 12;
//           }
//        if(tm == 1 || tm == 3 || tm == 5 || tm == 7 || tm == 8 || tm == 10 || tm == 12)
//            td = 31;
//        if(tm == 2)
//            if(MathMod(ty, 4) == 0)
//                td = 29;
//            else
//                td = 28;
//        if(tm == 4 || tm == 6 || tm == 9 || tm == 11)
//            td = 30;
//       }
//    return(StrToTime((string)ty + "." + (string)tm + "." + (string)td + " " + (string)th + ":" + (string)ti));
//   }

//void tf()
//   {
//    switch(Period())
//       {
//        case 1:
//            tf_saxtar = PERIOD_M15;
//            tfmu = 5;
//            tfm = PERIOD_M1;
//            atr_period = 15;
//            break;
//        case 5:
//            tf_saxtar = PERIOD_H1;
//            tfmu = 15;
//            tfm = PERIOD_M1;
//            atr_period = 12;
//            break;
//        case 15:
//            tf_saxtar = PERIOD_H4;
//            tfmu = 60;
//            tfm = PERIOD_M5;
//            atr_period = 16;
//            break;
//        case 30:
//            atr_period = 0;
//            tfmu = 60;
//            tfm = PERIOD_M15;
//            tf_saxtar = 0;
//            break;
//        case 60:
//            tf_saxtar = PERIOD_D1;
//            tfmu = 240;
//            tfm = PERIOD_M15;
//            atr_period = 24;
//            break;
//        case 240:
//            tf_saxtar = PERIOD_W1;
//            tfmu = 1440;
//            tfm = PERIOD_H1;
//            atr_period = 40;
//            break;
//        case 1440:
//            tf_saxtar = PERIOD_MN1;
//            tfm = PERIOD_H4;
//            tfmu = 10080;
//            atr_period = 22;
//            break;
//        case 10080:
//            tf_saxtar = PERIOD_W1;
//            tfmu = 43200;
//            tfm = PERIOD_D1;
//            atr_period = 48;
//            break;
//        case 43200:
//            tf_saxtar = PERIOD_MN1;
//            tfmu = 43200;
//            tfm = PERIOD_W1;
//            atr_period = 12;
//            break;
//        default:
//            atr_period = 0;
//       }
//   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// TH:
//1M=366.33 / 5.47
//1W=176.66 / 2.64
//1D=66.66 / 0.6666
//4h=27.33 / 0.4
//1h=13.33 / 0.2
//15m=7.33 / 0.1
//5m=3.66 / 0.055
//1m=1.66 / 0.026
//int TH(double i = 0.1333)
//   {
//    double b = Bid * i; //Open[0]
//    return(b < 1 ? (int)MathRound(b * 100) : (int)MathRound(b));
//   }

//double th_daily, b;
//th_daily = Bid * 0.6666;
//if(th_daily < 1)
//   {
//    th_daily *= 100;
//   }
//else
//   {
//    th_daily /= 10;
//   }
//Print(">>>>> ", th_daily);
//b = th_daily * i; //Open[0]
//return(int)MathRound(b);
//return(b < 1 ? (int)MathRound(b * 100) : (int)MathRound(b));

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TH(double i = 0.1333, double backtest = 0)
   {
    double th_daily, res, t_66;
    int DM;
    DM = First_Digits(backtest ? backtest : Bid);
    t_66 = 666.6 / (DM == 1 ? 10 : MathPow(10, DM));
    th_daily = (backtest ? backtest : Bid) * t_66;
//Print(t_66,">>>>> ", th_daily, " #",Bid);
    res = th_daily * i; //Open[0]
    return ((int)MathRound(res));
//return(b < 1 ? (int)MathRound(b * 100) : (int)MathRound(b));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int First_Digits(double p)
   {
    string ft[];
    int nd = StringSplit(string(p), '.', ft);
//Print(nd," #",ft[nd-2]," >>> ",StringLen(ft[nd-2]));
    if(nd == 1)
       {
        return(StringLen(ft[nd - 1]));
       }
    return(StringLen(ft[nd - 2]));
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string heiken_ashi(int i, double &h, double &l, double &o, double &c, int mode = 1)
   {
    double d1, d2;
    d1 = iCustom(NULL, PERIOD_CURRENT, mode ? "Heiken Ashi" : "TrillionLine", 0, i);
    d2 = iCustom(NULL, PERIOD_CURRENT, mode ? "Heiken Ashi" : "TrillionLine", 1, i);
    h = MathMax(d1, d2);
    l = MathMin(d1, d2);
    o = iCustom(NULL, PERIOD_CURRENT, mode ? "Heiken Ashi" : "TrillionLine", 2, i);
    c = iCustom(NULL, PERIOD_CURRENT, mode ? "Heiken Ashi" : "TrillionLine", 3, i);
    if(c > o)
       {
        return("up");
       }
    else
       {
        if(c < o)
           {
            return("down");
           }
       }
    return("[!]heiken_ashi ERROR!");
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HtoSEC(int h)
   {
    return(h * 3600);
   }

//int WhatSec(int t)
//{
//  return(int(iTime(NULL,t,1)-iTime(NULL,t,2)));
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//double HL_between2time(datetime t1, datetime t2, string _mode = "h", int _timeframe = 0, int c = 36)
//   {
//    int fbar = iBarShift(NULL, _timeframe, t1);
//    int sbar = iBarShift(NULL, _timeframe, t2);
//    int highest_index = iHighest(NULL, _timeframe, MODE_HIGH, c, fbar);
//    int lowest_index = iLowest(NULL, _timeframe, MODE_LOW, c, fbar);
//    return(_mode == "h" ? highest_index : lowest_index);
//   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SelectedObj(string &OL[])
   {
    ArrayResize(OL, ObjectsTotal());
    string x;
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        x = ObjectName(i);
        if(ObjectGet(x, OBJPROP_SELECTED))
           {
            OL[i] = x;
           }
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//string Find_obj(datetime t1, double p1, datetime t2, double p2)
//   {
//    string x;
//    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
//       {
//        x = ObjectName(i);
//        if(ObjectGet(x, OBJPROP_PRICE1) == p1 &&
//           ObjectGet(x, OBJPROP_PRICE2) == p2 &&
//           ObjectGet(x, OBJPROP_TIME1) == t1 &&
//           ObjectGet(x, OBJPROP_TIME2) == t2)
//           {
//            return(x);
//           }
//       }
//    return("000000000000");
//   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Find_obj(string n, string pass)
   {
    string x;
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        x = ObjectName(i);
        if(FindText(x, n) && FindText(x, pass))
           {
            return(x);
           }
       }
    return("000000000000");
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Obj_exist(string s)
   {
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        if(ObjectName(i) == s)
            return(true);
       }
    return(false);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteAllObject()
   {
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        ObjectDelete(ObjectName(i));
       }
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteObject2(string find1, string find2)
   {
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        string x = ObjectName(i);
        if(FindText(x, find1) && FindText(x, find2))
            ObjectDelete(x);
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FindText(string t1, string t2)
   {
    if(StringFind(t1, t2) == -1)
       {
        return(false);
       }
    else
       {
        return(true);
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ND(double i)
   {
    return(NormalizeDouble(i, Digits));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NS(string t, int len = 5)
   {
    return(StringSubstr(t, 0, len));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string doubletostring(double i)
   {
    return(DoubleToStr(i, 1));
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double topip(double i)
   {
    return(i * MathPow(10, Digits) / 10);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string timeframe(int i = 0)
   {
    string stf[];
    StringSplit(EnumToString(ENUM_TIMEFRAMES(i == 0 ? Period() : i)), '_', stf);
    return(stf[1]);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getMiddleBarIndex()
   {
    int iLeft   = WindowFirstVisibleBar();
    int ibars  = WindowBarsPerChart();
    return(iLeft - (WindowBarsPerChart() / 2));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void delete_ind()
   {
    string stf[];
    StringSplit(__FILE__, '.', stf);
    Print("ind: ", stf[0], " Deleted: ", ChartIndicatorDelete(0, 0, "th2"));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool newcandle(int p = 0)
   {
    static datetime  TIME;
    if(TIME != iTime(NULL, p == 0 ? Period() : p, 0))
       {
        TIME = iTime(NULL, p == 0 ? Period() : p, 0);
        return (true);
       }
    else
       {
        return(false);
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool newcandle2(int p = 0)
   {
    static datetime  TIME2;
    if(TIME2 != iTime(NULL, p == 0 ? Period() : p, 0))
       {
        TIME2 = iTime(NULL, p == 0 ? Period() : p, 0);
        return (true);
       }
    else
       {
        return(false);
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID = 0,             // chart's ID
                  const string            name = "Button",          // button name
                  const int               sub_window = 0,           // subwindow index
                  const int               x = 0,                    // X coordinate
                  const int               y = 0,                    // Y coordinate
                  const int               width = 50,               // button width
                  const int               height = 18,              // button height
                  const ENUM_BASE_CORNER  corner = CORNER_LEFT_LOWER, // chart corner for anchoring
                  const ENUM_ANCHOR_POINT anchor2 = ANCHOR_LOWER,
                  const string            text = "Button",          // text
                  const color             back_clr = C'236,233,216', // background color
                  const bool              state = false,
                  const color             clr = clrBlack,           // text color
                  const string            font = "Arial",           // font
                  const int               font_size = 10,           // font size
                  const color             border_clr = clrNONE,     // border color
                  const bool              back = false,             // in the background
                  const bool              selection = 0,        // highlight to move
                  const bool              hidden = false,            // hidden in the object list
                  const long              z_order = 0)              // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create the button
    if(!ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0))
       {
        Print(__FUNCTION__,
              ": failed to create the button! Error code = ", GetLastError());
        return(false);
       }
//--- set button coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor2);
//--- set button size
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
//--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set text color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set background color
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
//--- set border color
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- set button state
    ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonChangeColor(const string name = "Button", // button name
                       const color _color = clrBlack,
                       const long   chart_ID = 0) // text
   {
//--- reset the error value
    ResetLastError();
//--- change object text
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, _color))
       {
        Print(__FUNCTION__,
              ": failed to change the text! Error code = ", GetLastError());
        return(false);
       }
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonChangeBGColor(const string name = "Button", // button name
                         const color back_clr = C'236,233,216',
                         const long   chart_ID = 0) // text
   {
//--- reset the error value
    ResetLastError();
//--- change object text
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr))
       {
        Print(__FUNCTION__,
              ": failed to change the text! Error code = ", GetLastError());
        return(false);
       }
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonTextChange(const string name = "Button", // button name
                      const string text = "Text",
                      const long   chart_ID = 0) // text
   {
//--- reset the error value
    ResetLastError();
//--- change object text
    if(!ObjectSetString(chart_ID, name, OBJPROP_TEXT, text))
       {
        Print(__FUNCTION__,
              ": failed to change the text! Error code = ", GetLastError());
        return(false);
       }
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FiboTimesCreate(const long            chart_ID = 0,      // chart's ID
                     const string          name = "FiboTimes", // object name
                     const int             sub_window = 0,    // subwindow index
                     datetime              time1 = 0,         // first point time
                     double                price = 0,        // first point price
                     datetime              time2 = 0,         // second point time
                     const color           clr = clrNONE,      // object color
                     const ENUM_LINE_STYLE style = STYLE_SOLID, // object line style
                     const int             width = 1,         // object line width
                     const bool            back = true,      // in the background
                     const bool            selection = true,  // highlight to move
                     const bool            hidden = false,     // hidden in the object list
                     const long            z_order = 0)       // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create Fibonacci Time Zones by the given coordinates
    if(!ObjectCreate(chart_ID, name, OBJ_FIBOTIMES, sub_window, time1, price, time2, price))
       {
        Print(__FUNCTION__,
              ": failed to create \"Fibonacci Time Zones\"! Error code = ", GetLastError());
        return(false);
       }
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set line style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set line width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of highlighting the channel for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FiboTimesLevelsSet(
    string          text1,
    string          text2,
    color           colors = C'138,42,226',      // color of level lines
    const string    name = "FiboTimes",
    ENUM_LINE_STYLE styles = STYLE_DASHDOTDOT,      // style of level lines
    int             widths = 1,      // width of level lines // chart's ID //"FiboTimes") // object name
    const long      chart_ID = 0)
   {
//--- set the number of levels
    ObjectSetInteger(chart_ID, name, OBJPROP_LEVELS, 2);
    ObjectSetDouble(chart_ID, name, OBJPROP_LEVELVALUE, 0, 0);
    ObjectSetDouble(chart_ID, name, OBJPROP_LEVELVALUE, 1, 1);
    ObjectSetString(chart_ID, name, OBJPROP_LEVELTEXT, 0, text1);
    ObjectSetString(chart_ID, name, OBJPROP_LEVELTEXT, 1, text2);
//--- level color
    ObjectSetInteger(chart_ID, name, OBJPROP_LEVELCOLOR, colors);
//--- level style
    ObjectSetInteger(chart_ID, name, OBJPROP_LEVELSTYLE, styles);
//--- level width
    ObjectSetInteger(chart_ID, name, OBJPROP_LEVELWIDTH, widths);
//--- level description
//--- successful execution
    return(true);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool FiboTimesLevelsSet(int             levels,           // number of level lines
//                        double          &values[],        // values of level lines
//                        string          &text[],
//                        color           &colors[],        // color of level lines
//                        ENUM_LINE_STYLE &styles[],        // style of level lines
//                        int             &widths[],        // width of level lines
//                        const long      chart_ID = 0,     // chart's ID
//                        const string    name = "FiboTimes") // object name
//   {
////--- check array sizes
//    if(levels != ArraySize(colors) || levels != ArraySize(text) || levels != ArraySize(styles) ||
//       levels != ArraySize(widths) || levels != ArraySize(widths))
//       {
//        Print(__FUNCTION__, ": array length does not correspond to the number of levels, error!");
//        return(false);
//       }
////--- set the number of levels
//    ObjectSetInteger(chart_ID, name, OBJPROP_LEVELS, levels);
////--- set the properties of levels in the loop
//    for(int i = 0; i < levels; i++)
//       {
//        //--- level value
//        ObjectSetDouble(chart_ID, name, OBJPROP_LEVELVALUE, i, values[i]);
//        //--- level color
//        ObjectSetInteger(chart_ID, name, OBJPROP_LEVELCOLOR, i, colors[i]);
//        //--- level style
//        ObjectSetInteger(chart_ID, name, OBJPROP_LEVELSTYLE, i, styles[i]);
//        //--- level width
//        ObjectSetInteger(chart_ID, name, OBJPROP_LEVELWIDTH, i, widths[i]);
//        //--- level description
//        ObjectSetString(chart_ID, name, OBJPROP_LEVELTEXT, i, text[i]);
//       }
////--- successful execution
//    return(true);
//   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID = 0,             // chart's ID
                 const string            name = "Label",           // label name
                 const int               sub_window = 0,           // subwindow index
                 const int               x = 0,                    // X coordinate
                 const int               y = 0,                    // Y coordinate
                 const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text = "Label",           // text
                 const int               font_size = 10,           // font size
                 const color             clr = clrRed,             // color
                 const double            angle = 0.0,              // text slope
                 const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back = false,             // in the background
                 const bool              selection = false,        // highlight to move
                 const bool              hidden = true,            // hidden in the object list
                 const string            font = "Arial",           // font
                 const long              z_order = 0)              // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create a text label
    if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, 0, 0))
       {
        Print(__FUNCTION__,
              ": failed to create text label! Error code = ", GetLastError());
        return(false);
       }
//--- set label coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set the slope angle of the text
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID = 0,      // chart's ID
                 const string          name = "TrendLine", // line name
                 const int             sub_window = 0,    // subwindow index
                 datetime              time1 = 0,         // first point time
                 double                price1 = 0,        // first point price
                 datetime              time2 = 0,         // second point time
                 double                price2 = 0,        // second point price
                 const color           clr = clrRed,      // line color
                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style
                 const int             width = 1,         // line width
                 const bool            back = false,      // in the background const bool            selection = false,  // highlight to move
                 const bool            ray_right = false, // line's continuation to the right
                 const bool            hidden = true,     // hidden in the object list
                 const bool            selectable = true,
                 const string          des = "",
                 const bool            selected = false,
                 const long            z_order = 0)       // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create a trend line by the given coordinates
    if(!ObjectCreate(chart_ID, name, OBJ_TREND, sub_window, time1, price1, time2, price2))
       {
        Print(__FUNCTION__,
              ": failed to create a trend line! Error code = ", GetLastError());
        return(false);
       }
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, des);
//--- set line color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set line display style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set line width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selected);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right
    ObjectSetInteger(chart_ID, name, OBJPROP_RAY_RIGHT, ray_right);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID = 0,             // chart's ID
                const string            name = "Text",            // object name
                const int               sub_window = 0,           // subwindow index
                datetime                time = 0,                 // anchor point time
                double                  price = 0,                // anchor point price
                const string            text = "Text",            // the text itself
                const string            font = "Arial",           // font
                const int               font_size = 10,           // font size
                const color             clr = clrSienna,             // color
                const double            angle = 0.0,              // text slope
                const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT, // anchor type
                const bool              back = false,             // in the background
                const bool              selection = false,        // highlight to move
                const bool              hidden = true,            // hidden in the object list
                const long              z_order = 0)              // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create Text object
    if(!ObjectCreate(chart_ID, name, OBJ_TEXT, sub_window, time, price))
       {
        Print(__FUNCTION__,
              ": failed to create \"Text\" object! Error code = ", GetLastError());
        return(false);
       }
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set the slope angle of the text
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the object by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID = 0,      // chart's ID
                 const string          name = "HLine",    // line name
                 const int             sub_window = 0,    // subwindow index
                 double                price = 0,         // line price
                 const color           clr = clrRed,      // line color
                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style
                 const int             width = 1,         // line width
                 const bool            back = false,      // in the background
                 const bool            selection = true,  // highlight to move
                 const bool            hidden = false,     // hidden in the object list
                 const long            z_order = 0)       // priority for mouse click
   {
//--- if the price is not set, set it at the current Bid price level
    if(!price)
        price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
//--- reset the error value
    ResetLastError();
//--- create a horizontal line
    if(!ObjectCreate(chart_ID, name, OBJ_HLINE, sub_window, 0, price))
       {
        Print(__FUNCTION__,
              ": failed to create a horizontal line! Error code = ", GetLastError());
        return(false);
       }
//--- set line color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set line display style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set line width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VLineCreate(const long            chart_ID = 0,      // chart's ID
                 const string          name = "VLine",    // line name
                 const int             sub_window = 0,    // subwindow index
                 datetime              time = 0,          // line time
                 const color           clr = clrRed,      // line color
                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style
                 const int             width = 1,         // line width
                 const bool            back = false,      // in the background
                 const bool            selection = true,  // highlight to move
                 const bool            hidden = true,     // hidden in the object list
                 const long            z_order = 0)       // priority for mouse click
   {
//--- if the line time is not set, draw it via the last bar
    if(!time)
        time = TimeCurrent();
//--- reset the error value
    ResetLastError();
//--- create a vertical line
    if(!ObjectCreate(chart_ID, name, OBJ_VLINE, sub_window, time, 0))
       {
        Print(__FUNCTION__,
              ": failed to create a vertical line! Error code = ", GetLastError());
        return(false);
       }
//--- set line color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set line display style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set line width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID = 0,      // chart's ID
                     const string          name = "Rectangle", // rectangle name
                     const int             sub_window = 0,    // subwindow index
                     datetime              time1 = 0,         // first point time
                     double                price1 = 0,        // first point price
                     datetime              time2 = 0,         // second point time
                     double                price2 = 0,        // second point price
                     const color           clr = clrRed,      // rectangle color
                     const ENUM_LINE_STYLE style = STYLE_SOLID, // style of rectangle lines
                     const int             width = 1,         // width of rectangle lines
                     const bool            fill = false,      // filling rectangle with color
                     const bool            back = false,      // in the background  const bool            selection = true,  // highlight to move
                     const bool            hidden = false,     // hidden in the object list
                     const bool            selectable = true,
                     const long            z_order = 0)       // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- create a rectangle by the given coordinates
    if(!ObjectCreate(chart_ID, name, OBJ_RECTANGLE, sub_window, time1, price1, time2, price2))
       {
        Print(__FUNCTION__,
              ": failed to create a rectangle! Error code = ", GetLastError());
        return(false);
       }
//--- set rectangle color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set the style of rectangle lines
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set width of the rectangle lines
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- enable (true) or disable (false) the mode of filling the rectangle
    ObjectSetInteger(chart_ID, name, OBJPROP_FILL, fill);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FiboLevelsCreate(const long            chart_ID = 0,      // chart's ID
                      const string          name = "FiboLevels", // object name
                      const int             sub_window = 0,    // subwindow index
                      datetime              time1 = 0,         // first point time
                      double                price1 = 0,        // first point price
                      datetime              time2 = 0,         // second point time
                      double                price2 = 0,        // second point price
                      const color           clr = clrRed,      // object color
                      const ENUM_LINE_STYLE style = STYLE_SOLID, // object line style
                      const int             width = 1,         // object line width
                      const bool            back = false,      // in the background
                      const bool            selection = 1,  // highlight to move
                      const bool            ray_right = false, // object's continuation to the right
                      const bool            hidden = false,     // hidden in the object list
                      const long            z_order = 0)       // priority for mouse click
   {
//--- reset the error value
    ResetLastError();
//--- Create Fibonacci Retracement by the given coordinates
    if(!ObjectCreate(chart_ID, name, OBJ_FIBO, sub_window, time1, price1, time2, price2))
       {
        Print(__FUNCTION__,
              ": failed to create \"Fibonacci Retracement\"! Error code = ", GetLastError());
        return(false);
       }
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set line style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set line width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of highlighting the channel for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- enable (true) or disable (false) the mode of continuation of the object's display to the right
    ObjectSetInteger(chart_ID, name, OBJPROP_RAY_RIGHT, ray_right);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
   }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TOOLS_MQH__
#define __TOOLS_MQH__

#include "inputs.mqh"
#include "fibo/types.fibo.mqh"
#include "constants.mqh"

#define SPREAD    (Ask - Bid) / Point
#define NL        "\n"
#define WinMid    WindowFirstVisibleBar() - ((int)WindowBarsPerChart() / 2)
#define MiddlePrice ND(WindowPriceMax() - (WindowPriceMax() - WindowPriceMin()) / 2)

// Returns difference in minutes between local time and broker time
int GetBrokerTimeOffsetMinutes()
   {
    datetime localTime = TimeLocal();
    datetime serverTime = TimeCurrent();
    int diffInSeconds = (int)(localTime - serverTime);
    return diffInSeconds / 60;
   }


// Converts minute offset (e.g., 90 or -90) to "hh:mm" string format
string TimeOffsetToString(int offsetMinutes)
   {
    int hours = offsetMinutes / 60;
    int minutes = MathAbs(offsetMinutes % 60);
    string sign = (offsetMinutes >= 0) ? "+" : "-";
    return sign + StringFormat("%02d:%02d", MathAbs(hours), minutes);
   }


//+------------------------------------------------------------------+
//| Generate a unique object name                                    |
//| Format: <objectPrefix>-<timeOrRand3>-<rand6>                     |
//+------------------------------------------------------------------+
string GenerateRandomObjectName(const string &objectPrefix, int indexTime = -1)
   {
    string timeOrRandom;
    if(indexTime >= 0 && indexTime < Bars)
       {
        datetime barTime = Time[indexTime];
        timeOrRandom = IntegerToString((int)barTime);
       }
    else
       {
        int rand3 = 100 + MathRand() % 900; // Random 3-digit number
        timeOrRandom = IntegerToString(rand3);
       }
    int rand6 = 100000 + MathRand() % 900000; // Random 6-digit number
    return objectPrefix + "-" + timeOrRandom + "-" + IntegerToString(rand6);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteObject(string prefix)
   {
    for(int i = ObjectsTotal() - 1; i >= 0; i--)
       {
        string name = ObjectName(i);
        if(StringFind(name, prefix) != -1)
            ObjectDelete(0, name);
       }
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime FindBarTimeByPriceRange(double price1, datetime fromTime, double price2 = 0)
   {
    const int startIndex = iBarShift(NULL, 0, fromTime) - 1;
    double high, low;
    bool p1InRange, p2InRange;
    for(int i = startIndex; i >= 0; i--)
       {
        high = High[i];
        low  = Low[i];
        p1InRange = (price1 >= low && price1 <= high);
        p2InRange = (price2 >= low && price2 <= high);
        if(p1InRange || p2InRange)
           {
            return Time[i] + Period() * 60 * 3;
           }
       }
// Fallback: return start of current D1 bar + 1 day
    return iTime(NULL, PERIOD_D1, 0) + 86400;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void obj_set_color(color o)
   {
    string obj_selected[];
    ArrayResize(obj_selected, 0);
    SelectedObj(obj_selected);
    for(int i = 0; i < ArraySize(obj_selected); i++)
       {
        if(obj_selected[i] != NULL)
           {
            ObjectSet(obj_selected[i], OBJPROP_COLOR, o);
           }
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void obj_set_width(int v)
   {
    string obj_selected[];
    ArrayResize(obj_selected, 0);
    SelectedObj(obj_selected);
    for(int i = 0; i < ArraySize(obj_selected); i++)
       {
        if(obj_selected[i] != NULL)
           {
            ObjectSet(obj_selected[i], OBJPROP_WIDTH, v);
           }
       }
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string new_obj_name(string s, double p)
   {
    string myarray1[], mid_p;
    StringSplit(s, ' ', myarray1);
    mid_p = myarray1[1];
    StringReplace(s, mid_p, (string)p);
    return(s);
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int objexist(string pass)
   {
    int t = 0;
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        if(FindText(ObjectName(i), pass))
            ++t;
       }
    return(t);
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
bool RectangleCreate(const long            chart_ID = 0,      // chart's ID
                     const string          name = "Rectangle", // rectangle name
                     const int             sub_window = 0,    // subwindow index
                     datetime              time1 = 0,         // first g_point time
                     double                price1 = 0,        // first g_point price
                     datetime              time2 = 0,         // second g_point time
                     double                price2 = 0,        // second g_point price
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
bool TrendCreate(const long            chart_ID = 0,      // chart's ID
                 const string          name = "TrendLine", // line name
                 const int             sub_window = 0,    // subwindow index
                 datetime              time1 = 0,         // first g_point time
                 double                price1 = 0,        // first g_point price
                 datetime              time2 = 0,         // second g_point time
                 double                price2 = 0,        // second g_point price
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
double ND(double i)
   {
    return(NormalizeDouble(i, Digits));
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
//--- set the chart's corner, relative to which g_point coordinates are defined
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
bool FiboLevelsCreate(const long            chart_ID = 0,      // chart's ID
                      const string          name = "FiboLevels", // object name
                      const int             sub_window = 0,    // subwindow index
                      datetime              time1 = 0,         // first g_point time
                      double                price1 = 0,        // first g_point price
                      datetime              time2 = 0,         // second g_point time
                      double                price2 = 0,        // second g_point price
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































#endif

//+------------------------------------------------------------------+

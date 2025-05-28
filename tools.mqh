//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TOOLS_MQH__
#define __TOOLS_MQH__

#include "inputs.mqh"
#include "forall.mqh"
#include "types.mqh"
#include "constants.mqh"


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








#endif

//+------------------------------------------------------------------+

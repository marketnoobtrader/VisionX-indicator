//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "../inputs.mqh"

#include "../fibo/types.fibo.mqh"
#include "../constants.mqh"
#include "../tools.mqh"
#include "../globals.mqh"


// Function to create Fibonacci levels based on mode
void CreateFiboLevels(FiboMode mode, const string &ffInpLevels)
   {
    FiboLevel fiboLevels[];
    string fiboName = GenerateRandomObjectName(STATIC_DEFAULT_STRING);
    datetime middleTime = Time[getMiddleBarIndex()];
    string levelStrings[];
    int levelCount = StringSplit(ffInpLevels, ',', levelStrings);
    ArrayResize(fiboLevels, levelCount);
    if(mode == FIBO_MODE_RR)
       {
        fiboLevels[0].LabelText = "(SL) #%$";
        fiboLevels[2].LabelText = "EN #%$";
        for(int ii = 0; ii < levelCount; ii++)
           {
            fiboLevels[ii].PriceLevel = StrToDouble(levelStrings[ii]);
            fiboLevels[ii].LineColor = fibColor;
            fiboLevels[ii].LineStyle = fibStyle;
            fiboLevels[ii].LineWidth = fibWidth;
            if(ii + 3 < levelCount)
                fiboLevels[ii + 3].LabelText = "#" + IntegerToString(ii + 1);
           }
        FiboLevelsCreate(
            0, fiboName, 0, middleTime, MiddlePrice,
            middleTime + Period() * 60 * 5,
            MiddlePrice + 10 * Point,
            fibCenterColor, STYLE_DOT, 1, true
        );
       }
    else
        if(mode == FIBO_MODE_THIRDS)
           {
            const string labelsTHIRDS[] = { "(0%)", "(33%)", "(66%)", "(100%)" };
            for(int z = 0; z < levelCount && z < ArraySize(labelsTHIRDS); z++)
                fiboLevels[z].LabelText = labelsTHIRDS[z];
            for(int i = 0; i < levelCount; i++)
               {
                fiboLevels[i].PriceLevel = StrToDouble(levelStrings[i]);
                fiboLevels[i].LineColor = fibColor;
                fiboLevels[i].LineStyle = fibStyle;
                fiboLevels[i].LineWidth = fibWidth;
               }
            FiboLevelsCreate(
                0, fiboName, 0, middleTime, MiddlePrice,
                middleTime + Period() * 60 * 5, MiddlePrice + 10 * Point,
                fibCenterColor, STYLE_DOT, 1, true
            );
           }
        else
            if(mode == FIBO_MODE_QUARTERS)
               {
                const string labelsQUARTERS[] = { "(0%)", "(25%)", "(50%)", "(75%)", "(100%)" };
                for(int x = 0; x < levelCount && x < ArraySize(labelsQUARTERS); x++)
                    fiboLevels[x].LabelText = labelsQUARTERS[x];
                for(int y = 0; y < levelCount; y++)
                   {
                    fiboLevels[y].PriceLevel = StrToDouble(levelStrings[y]);
                    fiboLevels[y].LineColor = fibColor;
                    fiboLevels[y].LineStyle = fibStyle;
                    fiboLevels[y].LineWidth = fibWidth;
                   }
                FiboLevelsCreate(
                    0, fiboName, 0, middleTime, MiddlePrice,
                    middleTime + Period() * 60 * 5, MiddlePrice + 10 * Point,
                    fibCenterColor, STYLE_DOT, 1, true
                );
               }
    FiboLevelsSet(fiboLevels, levelCount, fiboName);
   }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FiboLevelsSet(const FiboLevel &FibValues[],
                   const int Size,
                   const string&    name)        // object name FibValues_name
   {
//--- set the number of levels
    ObjectSetInteger(0, name, OBJPROP_LEVELS, Size);
//--- set the properties of levels in the loop
    for(int i = 0; i < Size; i++)
       {
        //--- level value
        ObjectSetDouble(0, name, OBJPROP_LEVELVALUE, i, FibValues[i].PriceLevel);
        //--- level color
        ObjectSetInteger(0, name, OBJPROP_LEVELCOLOR, i, FibValues[i].LineColor);
        //--- level style
        ObjectSetInteger(0, name, OBJPROP_LEVELSTYLE, i, FibValues[i].LineStyle);
        //--- level width
        //if(FibValues[i].LevelDouble == 0.0 || FibValues[i].LevelDouble == 0.5 || FibValues[i].LevelDouble == 1.0)
        ObjectSetInteger(0, name, OBJPROP_LEVELWIDTH, i, FibValues[i].LineWidth);
        //--- level description
        //ObjectSetString(0,name,OBJPROP_LEVELTEXT,i,FibValues[i].Text+"%$");
        ObjectSetString(0, name, OBJPROP_LEVELTEXT, i, FibValues[i].LabelText);
       }
//--- successful execution
    return(true);
   }



//+------------------------------------------------------------------+

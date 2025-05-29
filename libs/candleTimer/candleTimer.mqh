//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

// ** SOURCE FROM: Foad Tahmasebi <tahmasebi.f@gmail.com> **

#ifndef __CANDLE_TIMER_MQH__
#define __CANDLE_TIMER_MQH__

#include "../tools.mqh"
#include "types.candleTimer.mqh"

//+------------------------------------------------------------------+
// CCTRLib Class
//+------------------------------------------------------------------+
class CCTRLib
   {
private:
    // Configuration
    CCTR_LOCATION    m_location;
    CCTR_ONOFF       m_displayServerTime;
    CCTR_ONOFF       m_playAlert;
    string           m_customAlertSound;
    int              m_fontSize;
    color            m_colour;
    string           m_objectName;

    // Internal variables
    datetime         m_leftTime;
    string           m_sTime;
    datetime         m_days;
    string           m_sCurrentTime;
    bool             m_alert_played;

    // Private methods
    void             CreateLabel();
    void             UpdateDisplay();
    void             CheckAlert();
    string           FormatTimeDisplay();

public:
    // Constructor
                     CCTRLib(CCTR_LOCATION location = CCTR_TOP_RIGHT,
            CCTR_ONOFF displayServerTime = CCTR_ON,
            CCTR_ONOFF playAlert = CCTR_OFF,
            string customAlertSound = "",
            int fontSize = 9,
            color colour = clrYellow);

    // Destructor
                    ~CCTRLib();

    // Public methods
    void             Init();
    void             Update();
    void             Deinit();

    // Configuration methods
    void             SetLocation(CCTR_LOCATION location) { m_location = location; }
    void             SetDisplayServerTime(CCTR_ONOFF display) { m_displayServerTime = display; }
    void             SetPlayAlert(CCTR_ONOFF alert) { m_playAlert = alert; }
    void             SetCustomAlertSound(string &sound) { m_customAlertSound = sound; }
    void             SetFontSize(int size) { m_fontSize = size; }
    void             SetColour(color clr) { m_colour = clr; }
    void             SetObjectName(string name) { m_objectName = name; }

    // Getter methods
    datetime         GetTimeRemaining() { return m_leftTime; }
    void             GetFormattedTime(string &destStr) { destStr = m_sTime; }
    bool             IsMarketClosed();
   };

//+------------------------------------------------------------------+
// Constructor
//+------------------------------------------------------------------+
CCTRLib::CCTRLib(CCTR_LOCATION location = CCTR_TOP_RIGHT,
                 CCTR_ONOFF displayServerTime = CCTR_ON,
                 CCTR_ONOFF playAlert = CCTR_OFF,
                 string customAlertSound = "",
                 int fontSize = 9,
                 color colour = clrYellow)
   {
    m_location = location;
    m_displayServerTime = displayServerTime;
    m_playAlert = playAlert;
    m_customAlertSound = customAlertSound;
    m_fontSize = fontSize;
    m_colour = colour;
    m_objectName = GenerateRandomObjectName(g_STATIC_DEFAULT_STRING);
    m_alert_played = false;
   }

//+------------------------------------------------------------------+
// Destructor
//+------------------------------------------------------------------+
CCTRLib::~CCTRLib()
   {
    Deinit();
   }

//+------------------------------------------------------------------+
// Initialize the library
//+------------------------------------------------------------------+
void CCTRLib::Init()
   {
    m_alert_played = false;
    CreateLabel();
   }

//+------------------------------------------------------------------+
// Clean up resources
//+------------------------------------------------------------------+
void CCTRLib::Deinit()
   {
    ObjectDelete(m_objectName);
    if(m_location == CCTR_COMMENT)
        Comment("");
   }

//+------------------------------------------------------------------+
// Update the display
//+------------------------------------------------------------------+
void CCTRLib::Update()
   {
// Calculate current time and time remaining
    m_sCurrentTime = TimeToStr(TimeCurrent(), TIME_SECONDS);
    m_leftTime = (_Period * 60) - (TimeCurrent() - Time[0]);
// Check for alert
    CheckAlert();
// Format time string
    m_sTime = TimeToStr(m_leftTime, TIME_SECONDS);
// Update display
    UpdateDisplay();
   }

//+------------------------------------------------------------------+
// Create label object
//+------------------------------------------------------------------+
void CCTRLib::CreateLabel()
   {
    if(m_location != CCTR_COMMENT)
       {
        ObjectCreate(m_objectName, OBJ_LABEL, 0, 0, 0);
        ObjectSet(m_objectName, OBJPROP_CORNER, m_location);
        ObjectSet(m_objectName, OBJPROP_XDISTANCE, 0);
        ObjectSet(m_objectName, OBJPROP_YDISTANCE, 2);
       }
   }

//+------------------------------------------------------------------+
// Check and play alert if needed
//+------------------------------------------------------------------+
void CCTRLib::CheckAlert()
   {
    if(m_playAlert == CCTR_ON && !m_alert_played && m_leftTime <= 5)
       {
        if(m_customAlertSound != "")
           {
            PlaySound(m_customAlertSound);
           }
        else
           {
            PlaySound("alert2.wav");
           }
        m_alert_played = true;
       }
    if(m_leftTime > 5)
       {
        m_alert_played = false;
       }
   }

//+------------------------------------------------------------------+
// Update the display based on current settings
//+------------------------------------------------------------------+
void CCTRLib::UpdateDisplay()
   {
    string displayText = FormatTimeDisplay();
    if(m_location == CCTR_COMMENT)
       {
        Comment("CCTR: " + displayText);
       }
    else
       {
        ObjectSetText(m_objectName, displayText, m_fontSize, "Arial Bold Italic", m_colour);
       }
   }

//+------------------------------------------------------------------+
// Format time display string
//+------------------------------------------------------------------+
string CCTRLib::FormatTimeDisplay()
   {
    string result = "";
    if(IsMarketClosed())
       {
        result = "Market Is Closed";
       }
    else
       {
        if(Period() == PERIOD_MN1 || Period() == PERIOD_W1)
           {
            m_days = ((m_leftTime / 60) / 60) / 24;
            result = IntegerToString(m_days) + "D - " + m_sTime;
           }
        else
           {
            result = m_sTime;
           }
        // Add server time if enabled
        if(m_displayServerTime == CCTR_ON)
           {
            result += " [" + m_sCurrentTime + "]";
           }
       }
    return result;
   }

//+------------------------------------------------------------------+
// Check if market is closed (weekend)
//+------------------------------------------------------------------+
bool CCTRLib::IsMarketClosed()
   {
    return (DayOfWeek() == 0 || DayOfWeek() == 6);
   }

#endif

//+------------------------------------------------------------------+
// Example usage indicator
//+------------------------------------------------------------------+
/*
// Example of how to use this library in an indicator:

#include "candle-timer.mqh"

CCTRLib* g_cctr;

int OnInit()
{
   g_cctr = new CCTRLib(CCTR_TOP_RIGHT, CCTR_ON, CCTR_OFF, "", 9, clrYellow, "MyCCTR");
   g_cctr.Init();
   EventSetMillisecondTimer(250);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   delete g_cctr;
   g_cctr = NULL;
}

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
   if(IsVisualMode())
   {
      g_cctr.Update();
   }
   return(rates_total);
}

void OnTimer()
{
   g_cctr.Update();
}
*/

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

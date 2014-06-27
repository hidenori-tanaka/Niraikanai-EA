//**********************************************************************
//  
// PerfectOrderMA_ind.mq4
// Copyright 2014 Mr.Racoon
//        
// プロトタイプとしてルール成立時にアラートを出すインジケータを作成
//        
// 変更履歴:　　　　　 
//    06/10/2014 hidenori@v102.vaio.ne.jp
//        version 1.0
//            - 
//
//**********************************************************************

// プリプロセッサ命令
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1  Red
#property indicator_color2  Green
#property indicator_level1  0
#property indicator_level2  0

// 指標バッファ用の配列の宣言
double buffShort[];
double buffLong[];

// 外部パラメータ
extern int periodShort  = 40;
extern int periodLong   = 200;

extern double lots      = 0.1;
extern int slippage     = 1;
extern int slPips       = 2;
extern int tpPips       = 4;
extern string COMMENT   = "ENTRY"
extern int MAGIG        = 100;

extern string indEU1    = "17:30"
extern string indUS1    = "21:30"
extern string indUS2    = "23:00"

extern double thSlope   = 2.5;

datetime dtEU1;
datetime dtUS1;
datetime dtUS2;

//----------------------------------------------------------------------
//
// 初期化関数
//
//----------------------------------------------------------------------
int OnInit()
{
    // インジケーター名
    IndicatorShortName("Perfect Order MA")

    // 指標バッファの割り当て
    SetIndexBuffer(0, buffShort);
    SetIndexBuffer(1, buffLong);
    
    // 指標ラベルの設定
    string labelShort = "MA("+periodShort+")";
    string labelLong = "MA("+periodLong+")";

    SedIndexLable(0, labelShort)
    SedIndexLable(1, labelLong)
    
    // 指標時間設定
    dtEU1 = StrToTime(indEU1);
    dtUS1 = StrToTime(indUS1);
    dtUS2 = StrToTime(indUS2);
    
    retrun(0);
}

//----------------------------------------------------------------------
//
// 初期指標計算
//
//----------------------------------------------------------------------
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
    int i;
    color cOrder;
    
    //
    // インジケーター更新
    //
    int limit = Bars - indicatorCounted();
    for(i=limit-1 ; i>=0 ; i--){
        buffShort[i] = iMA(NULL, 0, periodShort, 0, MODE_SMA, PRICE_CLISE, i);
        buffLong[i]  = iMA(NULL, 0, periodLong,  0, MODE_SMA, PRICE_CLISE, i);
    }

    //
    // ポジション保有時
    //
    int ticket;
    for(i=0 ; i<OrderTotal() ; i++){
        if(isPositionCloseTime()){
            if(OrderSelect(i, SELECT_BY_POS) == false){
                break;
            }
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != MAGIC){
                continue;
            }
            int type = OrderType();
            if(type == OP_BUY || type == OP_SELL){
                if(type == OP_BUY){
                    cOrder = Blue;
                }else{
                    cOrder = Red;
                }
                ticket = OrderTicket()
                OrderClose(ticket, OrderLots(), OrderClosePrice(), slippage, cOrder);        
            }
        }
    }
    
    //
    // エントリー判断
    //
    if(isEntryDeniedTime()){
        return(0)
    }

    double stopPrice    = 0;
    double takeProfit   = 0;
    
    // 傾き計算
    double slopShort, slopeLong;
    slopShort = calcSlope(buffShort, 3);
    slopeLong  = calcSlope(buffLong, 3);

    if(buffShort[0] > buffLong[0]){
        //
        // ロング検討
        //
        
        // 傾き
        if(!((slopShort > thSlope) && (slopeLong > thSlope))){
            return(0)
        }
        
        // 終値
        if(!(close[0] > buffShort[0]){
            return (0)
        }
        
        // 発注
        if(slPips !=0){
            stopPrice = Ask - slPips*Point;
        }
        if(tpPips !=0){
            takeProfit = Ask + slPips*Point;
        }
        OrderSend(NULL, OP_BUY, lots, Ask, slippage, stopPrice, takeProfit, COMMENT, MAGIC, Blue);

    }elseif(buffShort[0] < buffLong[0]){
        //
        // ショート検討
        //
        
        // 傾き
        if(!(slopShort < -thSlope && slopeLong < -thSlope)){
            return(0)
        }
        
        // 終値
        if(!(close[0] < buffShort[0]){
            return (0)
        }
        
        // 発注
        // 発注
        if(slPips !=0){
            stopPrice = Bid + slPips*Point;
        }
        if(tpPips !=0){
            takeProfit = Bid - slPips*Point;
        }
        OrderSend(NULL, OP_SELL, lots, Ask, slippage, stopPrice, takeProfit, COMMENT, MAGIC, Red);
    }
    return(0);
}

//----------------------------------------------------------------------
//
// 傾き計算
//
//----------------------------------------------------------------------
int calcSlope(double buff[], int n)
{
    int i;

    double a, b, c, d, e;
    a = 0;  
    b = 0;  
    c = 0;
    d = 0;
    e = 0;
    
    for(i=0 ; i<n ; i++){
        a += buff[i]*(n-i)
        b += buff[i];
        c += (n-i);
        d += buff[i]^2;
        e += buff[i];
    }
    
    a = (n*a - b*c)/(n*d-e^2);
    
    return(a);
}

//----------------------------------------------------------------------
//
// 指標発表5分前
//
//----------------------------------------------------------------------
bool isPositionCloseTime()
{
    // 現在時刻取得
    datetime dtNow = TimeCurrent()
    datetime dtDiff;
    
    dtDiff = dtEU1 - dtNow;
    if((dtDiff >= 0) and (timeDiff < 300)) {
        return(true)
    }
    dtDiff = dtUS1 - dtNow;
    if((dtDiff >= 0) and (timeDiff < 300)) {
        return(true)
    }
    dtDiff = dtUS2 - dtNow;
    if((dtDiff >= 0) and (timeDiff < 300)) {
        return(true)
    }
    return(false)
}

//----------------------------------------------------------------------
//
// 指標発表前後15分
//
//----------------------------------------------------------------------
bool isEntryDeniedTime()
{
    // 現在時刻取得
    datetime dtNow = TimeCurrent()
    datetime dtDiff;
    
    dtDiff = dtEU1 - dtNow;
    if((dtDiff >= -900) and (timeDiff < 900)) {
        return(true)
    }
    dtDiff = dtUS1 - dtNow;
    if((dtDiff >= -900) and (timeDiff < 900)) {
        return(true)
    }
    dtDiff = dtUS2 - dtNow;
    if((dtDiff >= -900) and (timeDiff < 900)) {
        return(true)
    }
    return(false)
}

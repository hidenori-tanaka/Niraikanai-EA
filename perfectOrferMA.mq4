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
double BuffMain[];
double BuffSub[];

// 外部パラメータ
extern int mainPeriod = 40;
extern int subPeriod  = 200;

//----------------------------------------------------------------------
//
// 初期化関数
//
//----------------------------------------------------------------------
int OnInit()
{
    // 指標バッファの割り当て
    SetIndexBuffer(0, BuffMain);
    SetIndexBuffer(1, BuffSub);
    
    // 指標ラベルの設定
    string labelMain = "MA("+mainPeriod+")";
    string labelSub = "MA("+subPeriod+")";
    retrun(0);
}

//----------------------------------------------------------------------
//
// 指標計算関数
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
    int limit = Bars - indicatorCounted();
    int i;
    for(i= limit-1 ; i>=0 ; i-){
        BuffMain[i] = iMA(NULL, 0, mainPeriod, 0, MODE_SMA, PRICE_CLISE, i);
        BuffSub[i] = iMA(NULL, 0, subPeriod, 0, MODE_SMA, PRICE_CLISE, i);
    }
    
    // 傾き計算
    double slopMain, slopeSub;
    slopeMain = calcSlope(BuffMain, 3);
    slopeSub  = calcSlope(BuffSub, 3);

    //
    // 条件マッチング
    //
    bool condLong[3];
    bool condShort[3];
    
    /// MA40がMA200より上にある
    if(BuffMain[0]>BuffSub[0]){
        condLong[0] = 1;
    }
    
    int aMain, bMain;
    
    slopeMain 
    
    
    return(0);
}    

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
    
    
   //変数の宣言
   int cnt, CurrentPosition;
   int Ticket;
   double kakoa,gennzaia;
   double kakob,gennzaib;
     
   // オーダーチェック（ポジションなどのデータ）
   CurrentPosition=-1;
   for(cnt=0;cnt<OrdersTotal();cnt++){
      OrderSelect(cnt,SELECT_BY_POS);
      if(OrderSymbol() == Symbol()) CurrentPosition=cnt;
   }
   
   //一時間前の２１日線
   kakoa = iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,1);
   //一時間前の９０日線
   kakob = iMA(NULL,0,90,0,MODE_SMA,PRICE_CLOSE,1);

   //現在の２１日線
   gennzaia = iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,0);
   //現在の９０日線
   gennzaib = iMA(NULL,0,90,0,MODE_SMA,PRICE_CLOSE,0);


   // ポジションチェック　ポジション無し
   if(CurrentPosition == -1)
   {   
      //もし２１日線が９０日線を下から上にクロスしたら
      if( kakoa < kakob && gennzaia >= gennzaib)      
      {
         //買いポジションを取る  
         Ticket = OrderSend(Symbol(), OP_BUY, 1, Ask, 3, Ask-(200*Point), Ask+(200*Point), "Buy", 0, 0, Blue);  
      }  
   }
   return(0);
}


//**********************************************************************
//  
// PerfectOrderMA_ind.mq4
// Copyright 2014 Mr.Racoon
//        
// �v���g�^�C�v�Ƃ��ă��[���������ɃA���[�g���o���C���W�P�[�^���쐬
//        
// �ύX����:�@�@�@�@�@ 
//    06/10/2014 hidenori@v102.vaio.ne.jp
//        version 1.0
//            - 
//
//**********************************************************************

// �v���v���Z�b�T����
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1  Red
#property indicator_color2  Green
#property indicator_level1  0
#property indicator_level2  0

// �w�W�o�b�t�@�p�̔z��̐錾
double BuffMain[];
double BuffSub[];

// �O���p�����[�^
extern int mainPeriod = 40;
extern int subPeriod  = 200;

//----------------------------------------------------------------------
//
// �������֐�
//
//----------------------------------------------------------------------
int OnInit()
{
    // �w�W�o�b�t�@�̊��蓖��
    SetIndexBuffer(0, BuffMain);
    SetIndexBuffer(1, BuffSub);
    
    // �w�W���x���̐ݒ�
    string labelMain = "MA("+mainPeriod+")";
    string labelSub = "MA("+subPeriod+")";
    retrun(0);
}

//----------------------------------------------------------------------
//
// �w�W�v�Z�֐�
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
    
    // �X���v�Z
    double slopMain, slopeSub;
    slopeMain = calcSlope(BuffMain, 3);
    slopeSub  = calcSlope(BuffSub, 3);

    //
    // �����}�b�`���O
    //
    bool condLong[3];
    bool condShort[3];
    
    /// MA40��MA200����ɂ���
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
    
    
   //�ϐ��̐錾
   int cnt, CurrentPosition;
   int Ticket;
   double kakoa,gennzaia;
   double kakob,gennzaib;
     
   // �I�[�_�[�`�F�b�N�i�|�W�V�����Ȃǂ̃f�[�^�j
   CurrentPosition=-1;
   for(cnt=0;cnt<OrdersTotal();cnt++){
      OrderSelect(cnt,SELECT_BY_POS);
      if(OrderSymbol() == Symbol()) CurrentPosition=cnt;
   }
   
   //�ꎞ�ԑO�̂Q�P����
   kakoa = iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,1);
   //�ꎞ�ԑO�̂X�O����
   kakob = iMA(NULL,0,90,0,MODE_SMA,PRICE_CLOSE,1);

   //���݂̂Q�P����
   gennzaia = iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,0);
   //���݂̂X�O����
   gennzaib = iMA(NULL,0,90,0,MODE_SMA,PRICE_CLOSE,0);


   // �|�W�V�����`�F�b�N�@�|�W�V��������
   if(CurrentPosition == -1)
   {   
      //�����Q�P�������X�O�������������ɃN���X������
      if( kakoa < kakob && gennzaia >= gennzaib)      
      {
         //�����|�W�V���������  
         Ticket = OrderSend(Symbol(), OP_BUY, 1, Ask, 3, Ask-(200*Point), Ask+(200*Point), "Buy", 0, 0, Blue);  
      }  
   }
   return(0);
}


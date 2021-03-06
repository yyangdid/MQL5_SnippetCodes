﻿//+------------------------------------------------------------------+
//|                                                ontrade_trace.mq5 |
//|                                    André Augusto Giannotti Scotá |
//|                              https://sites.google.com/view/a2gs/ |
//+------------------------------------------------------------------+

int orderTotal = 0;
int dealsTotal = 0;
int positionsTotal = 0;

int OnInit()
{
   orderTotal     = OrdersTotal();
   dealsTotal     = HistoryDealsTotal();
   positionsTotal = PositionsTotal();

   return(INIT_SUCCEEDED);
}

void OnTrade()
{
   string msg = "";
   int currentOrderTotal     = OrdersTotal();
   int currentDealsTotal     = HistoryDealsTotal();
   int currentPositionsTotal = PositionsTotal();
   
   if(orderTotal     == currentOrderTotal &&
      dealsTotal     == currentDealsTotal &&
      positionsTotal == currentPositionsTotal){
      Print("Alteracao de ordem pendente ou posicao");
      return;
   }

   if(orderTotal < currentOrderTotal)              msg += "ORDEM ADICIONADA    ";
   else if(orderTotal > currentOrderTotal)         msg += "ORDEM REMOVIDA      ";

   if(dealsTotal < currentDealsTotal)              msg += "DEAL ADICIONADO     ";
   else if(dealsTotal > currentDealsTotal)         msg += "DEAL REMOVIDO       ";

   if(positionsTotal < currentPositionsTotal)      msg += "POSITION ADICIONADO ";
   else if(positionsTotal > currentPositionsTotal) msg += "POSITION REMOVIDO   ";

   orderTotal     = currentOrderTotal;
   dealsTotal     = currentDealsTotal;
   positionsTotal = currentPositionsTotal;

   printf("%sOrdens: [%02d] Deals: [%02d] Positions: [%02d]", msg, orderTotal, dealsTotal, positionsTotal);
}

void OnDeinit(const int reason)
{
}

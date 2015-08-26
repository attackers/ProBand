//
//  TradeRecordModel.h
//  ProBand
//
//  Created by star.zxc on 15/7/9.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface TradeRecordModel : BaseModel
@property (nonatomic, strong)NSString *bandAccount;
@property (nonatomic, assign)NSNumber *payMoney;//支付金额
@property (nonatomic, strong)NSString *companyName;//商户名
@property (nonatomic, strong)NSString *companyAccount;//商户号
@property (nonatomic, strong)NSString *terminalAccount;//终端号
@property (nonatomic, strong)NSString *certificate;//凭证号
@property (nonatomic, strong)NSDate *tradeDate;//交易时间


@end

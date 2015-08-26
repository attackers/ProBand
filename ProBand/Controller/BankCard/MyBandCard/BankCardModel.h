//
//  BankCardModel.h
//  ProBand
//
//  Created by star.zxc on 15/6/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface BankCardModel : BaseModel

@property (nonatomic, strong)NSString *bandName;//银行名
@property (nonatomic, strong)NSString *account;//银行账户
@property (nonatomic, strong)NSString *imageName;//银行卡图片名
@property (nonatomic, assign)BOOL isDefaultCard;//是否默认银行卡
@end

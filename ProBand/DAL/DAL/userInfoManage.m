#import "userInfoManage.h"
#import "DataBase.h"
@implementation userInfoManage
+(NSArray *)findAll{
    return [self findBySql:@"SELECT * FROM t_userInfo order by id desc"];
}
+(NSArray *)getPageList:(int)pageId
{
    NSInteger fromRow=pageId*15;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_userInfo order by id desc limit %ld,15",(long)fromRow];
    return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_userInfo where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_userInfo where id=%@",Id]];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    int count=[rs columnCount];
    while ([rs next]){for (int i=0; i<count; i++)
    {
        NSString *columnName=[NSString stringWithFormat:@"%@",[rs columnNameForIndex:i]];
        NSString *columnValue = [NSString stringWithFormat:@"%@",[rs objectForColumnName:columnName]];
        [dic setObject:columnValue forKey:columnName];
    }
    }
    [rs close];
    NSDictionary *dics=[NSDictionary dictionaryWithDictionary:dic];
    return  dics;
}
+ (NSArray *) findBySql:(NSString *)sql
{
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs;
    rs = [dataBase executeQuery:sql];
    NSMutableArray *userInfos = [[NSMutableArray alloc] init];
    while ([rs next])
    {
        //NSLog(@"next");
        UserInfoModel *model= [[UserInfoModel alloc] init];
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
        model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
        model.userName = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userName"]];
        model.height = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"height"]];
        model.weight = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weight"]];
        model.gender = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"gender"]];
        model.birthDay = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"birthDay"]];
        model.imageUrl = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"imageUrl"]];
        model.weightUnit = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weightUnit"]];
        model.heightUnit = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"heightUnit"]];
        [userInfos addObject:model];
    }
    [rs close];
    [dataBase close];
    return userInfos;
}
+(UserInfoModel *)getModelById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_userInfo where id=%@",Id]];
    UserInfoModel *model= [[UserInfoModel alloc] init];
    while ([rs next]) {
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
        model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
        model.userName = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userName"]];
        model.height = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"height"]];
        model.weight = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weight"]];
        model.gender = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"gender"]];
        model.birthDay = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"birthDay"]];
        model.imageUrl = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"imageUrl"]];
        model.weightUnit = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weightUnit"]];
        model.heightUnit = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"heightUnit"]];
    }
    return  model;
}
+ (int) count{
    FMDatabase *dataBase = [DataBase setup];
    int userInfoCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_userInfo "] intValue];
    [dataBase close];
    return userInfoCount;
}
+ (int)getMaxId
{
    FMDatabase *dataBase = [DataBase setup];
    int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_userInfo "] intValue];
    if (maxid==1) {
        maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='userInfo' "] intValue]+1;
    }
    [dataBase close];
    return maxid+1;
}
+(int)updateId:(NSString *)Id userId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *time=[DataBase getCurDateTime];
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_userInfo SET    userId = '%@' , userName = '%@' , height = '%@' , weight = '%@' , gender = '%@' , birthDay = '%@' , imageUrl = '%@' , weightUnit = '%@' , heightUnit = '%@'    where id= '%@'",  userId,userName,height,weight,gender,birthDay,imageUrl,weightUnit,heightUnit,Id
                   ]; BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}
//如果原来有数据，则将原数据替换掉;如果没有则需要插入一条数据
+ (BOOL)updateUserId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_userInfo SET    userId = '%@' , userName = '%@' , height = '%@' , weight = '%@' , gender = '%@' , birthDay = '%@' , imageUrl = '%@' , weightUnit = '%@' , heightUnit = '%@'    where userId= '%@'",  userId,userName,height,weight,gender,birthDay,imageUrl,weightUnit,heightUnit,userId
                     ];
    BOOL result = [dataBase executeUpdate:sql];
    [dataBase close];
    return result;
}
+ (int)remove:(NSString *) ID
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_userInfo WHERE ID = %@",ID]];	[dataBase close];
    return bResult;
}
+ (int)adduserId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit {
    FMDatabase *dataBase = [DataBase setup];
    NSLog(@"addtitle");
    int lastId=0;
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_userInfo (userId,userName,height,weight,gender,birthDay,imageUrl,weightUnit,heightUnit)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@') ",userId,userName,height,weight,gender,birthDay,imageUrl,weightUnit,heightUnit];
    if( [dataBase executeUpdate:sql])
    {
        lastId=[dataBase lastInsertRowId];
    }
    [dataBase close];
    return lastId;
}



+(UserInfoModel *)ParserSeverInfo:(id)result
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    UserInfoModel  *userInfoObj = [[UserInfoModel alloc]init];
    if (dic.count>0) {
        if ([dic[@"retcode"] integerValue] == 10000) {
            userInfoObj.userId = [Singleton getUserID];
            NSString *tempStr = dic[@"retstring"];
            NSArray *tempArr = [NSJSONSerialization JSONObjectWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *tempDic = tempArr[0];
            userInfoObj.gender = tempDic[@"gender"];
            
            NSString *personalSettingStr = tempDic[@"personalSetting"];
            NSDictionary *personalSettingDic = [NSJSONSerialization JSONObjectWithData:[personalSettingStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            // NSLog(@"~~~~personalSettingDic~~~~~%@",personalSettingDic);
            userInfoObj.birthDay = personalSettingDic[@"birthday"];//接口中birthDay已改为birthday，故修改此处
            NSArray *heightArr = [personalSettingDic[@"height"] componentsSeparatedByString:@"-"];
            userInfoObj.height = heightArr[0];
            userInfoObj.heightUnit = heightArr[1];
            NSArray *weightArr = [personalSettingDic[@"weight"] componentsSeparatedByString:@"-"];
            userInfoObj.weight = weightArr[0];
            userInfoObj.weightUnit = weightArr[1];
            userInfoObj.userName = personalSettingDic[@"nikeName"];
            userInfoObj.imageUrl = personalSettingDic[@"imageUrl"];
        }
    }
    return userInfoObj;
    
}
@end

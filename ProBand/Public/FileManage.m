//
//  FileManage.m
//  BusMap
//
//  Created by zhu xian on 11-12-5.
//  Copyright 2011 z. All rights reserved.
#import "FileManage.h"
#import "PublicFunction.h"
@implementation FileManage

+(BOOL)saveCrash:(NSString *)str
{
  NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/pictures"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
		[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
	}
  
    NSString *path=[documentsDirectory stringByAppendingPathComponent:@"crashfile.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
       
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else
    {
        BOOL succeed = [str writeToFile:[documentsDirectory stringByAppendingPathComponent:@"crashfile.txt"]
                             atomically:YES encoding:NSUTF8StringEncoding error:&error];
        return succeed;
    }
   
    return  true;
   
   
   

}
+(NSString *)getCrash
{
    NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/pictures"];
    
    NSError *error;
 
   return [NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"crashfile.txt"] encoding:NSUTF8StringEncoding error:&error];
   
    
}


+(BOOL)saveImg:(UIImage *)theImg imageName:(NSString *)imageName
{
	NSData* UIImagePNGRepresentation(UIImage *image);
	NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
	NSData* imageData = UIImagePNGRepresentation(theImg);
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/pictures"];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) 
    {
        
      
		[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
          [PublicFunction addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:documentsDirectory]];//加上离线属性防止备份到iClound
	}
	//NSLog(@"createDirectoryerror=%@",error);
	// Now we get the full path to the file
	NSString* fullPathToFile = [NSString stringWithFormat:@"%@/%@",documentsDirectory,imageName];
	// and then we write it out
	NSLog(@"SavePath=%@",fullPathToFile);
	return [imageData writeToFile:fullPathToFile atomically:NO];
}

+(UIImage*) getImageWithName:(NSString*)aFileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	NSString *filePath=[NSString stringWithFormat:@"%@/pictures/%@",documentsDirectory,aFileName];
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	UIImage* image = nil; 
	if(!success)
	{
        NSLog(@"imgNotExists");
		return nil;
	}
	else 
	{  NSLog(@"imgExists");
		image = [[UIImage alloc] initWithContentsOfFile:filePath];                                                                                                                                                                                               
	}
	return image;
}
+(BOOL) delWithImageName:(NSString*)aFileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/pictures/%@",documentsDirectory,aFileName];
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	if(!success)
	{NSLog(@"imgNotExists");
		return FALSE;
	}
	else 
	{  NSLog(@"imgExists");
		return [fileManager removeItemAtPath:filePath error:nil];
		
	}

	//return [image;
}
+(BOOL) delWithImagesArray:(NSArray *)imageArray
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (int i=0; i<imageArray.count; i++) {
        
        NSString *filePath=[NSString stringWithFormat:@"%@/pictures/%@",documentsDirectory,[imageArray objectAtIndex:i]];
        
        BOOL success = [fileManager fileExistsAtPath:filePath];
        if(!success)
        {NSLog(@"imgNotExists");
            return FALSE;
        }
        else
        {  NSLog(@"imgExists");
            return [fileManager removeItemAtPath:filePath error:nil];
            
        }
    }
	
    return true;
	//return [image;
}

+(BOOL)saveFile:(UIImage *)theImg folderName:(NSString *)folderName fileName:(NSString *)fileName
{
	NSData* UIImagePNGRepresentation(UIImage *image);
	NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
	NSData* imageData = UIImagePNGRepresentation(theImg);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@Documents/%@",NSHomeDirectory(),folderName];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
	}
	//NSLog(@"createDirectoryerror=%@",error);
	// Now we get the full path to the file
	NSString* fullPathToFile = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName];
	// and then we write it out
	NSLog(@"SavePath=%@",fullPathToFile);
	return [imageData writeToFile:fullPathToFile atomically:NO];
	
}
+(UIImage*) getFileWithFolder:(NSString*)folderName fileName:(NSString*)fileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,folderName,fileName];
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	
	UIImage* image = nil; 
	
	if(!success)
	{NSLog(@"fileNotExists");
		return nil;
	}
	else 
	{  NSLog(@"fileExists");
		image = [[UIImage alloc] initWithContentsOfFile:filePath];                                                                                                                                                                                              
		
	}
	return image;
}
+(int) getFileSize:(NSString*)folderName fileName:(NSString*)fileName
{
	int fileSize=0;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,folderName,fileName];
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	
	UIImage* image = nil; 
	
	if(!success)
	{NSLog(@"fileNotExists");
		return 0;
	}
	else 
	{  NSLog(@"fileExists");
		image = [[UIImage alloc] initWithContentsOfFile:filePath];   
		NSDictionary *fileAttributes=[fileManager fileAttributesAtPath:filePath traverseLink:YES];
		
		if (fileAttributes!=nil) {
			
			fileSize=[[fileAttributes objectForKey:NSFileSize] intValue]/1024;
			//fileSize=[fileAttributes objectForKey:NSFileSize];
		}
		fileAttributes=nil;
		
	}
	fileManager=nil;
	NSLog(@"文件%@的大小=%d k",fileName,fileSize);
	
	return fileSize;
}

+(NSString *) getFilePathByFileName:(NSString*)fileName
{
	//int fileSize=0;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/pictures/%@",documentsDirectory,fileName];
	
   
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    
	return @"";
}


+(int) getFileSizeByPath:(NSString*)filePath
{
	int fileSize=0;
   
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	
	UIImage* image = nil;
	
	if(!success)
	{NSLog(@"fileNotExists");
		return 0;
	}
	else
	{  NSLog(@"fileExists");
		image = [[UIImage alloc] initWithContentsOfFile:filePath];
		NSDictionary *fileAttributes=[fileManager fileAttributesAtPath:filePath traverseLink:YES];
		
		if (fileAttributes!=nil) {
			
			fileSize=[[fileAttributes objectForKey:NSFileSize] intValue]/1024;
			//fileSize=[fileAttributes objectForKey:NSFileSize];
		}
		fileAttributes=nil;
		
	}
	fileManager=nil;
	NSLog(@"文件的大小=%d k",fileSize);
	
	return fileSize;
}



+(BOOL) delWithFolderName:(NSString*)folderName fileName:(NSString *)fileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,folderName,fileName];
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	
	
	if(!success)
	{NSLog(@"fileNotExists");
		return FALSE;
	}
	else 
	{  NSLog(@"fileExists");
		return [fileManager removeItemAtPath:filePath error:nil];
		
	}
	
	
	//return [image;
}
+(BOOL) delWithAudioName:(NSString *)fileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	NSString *filePath=[NSString stringWithFormat:@"%@/Audio/%@",documentsDirectory,fileName];
	
	//NSLog(@"readFromPath=%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:filePath];
	
	
	if(!success)
	{NSLog(@"fileNotExists");
		return FALSE;
	}
	else 
	{  NSLog(@"fileExists");
		
		return [fileManager removeItemAtPath:filePath error:nil];
		
	}
	
	
	//return [image;
}
+ (BOOL)writeToTextFile:(NSString *)str  FileName:(NSString *)fileName
{
	//NSString *myPath = [[NSBundle mainBundle] bundlePath];
//	NSString *curDir = [[NSFileManager defaultManager] currentDirectoryPath];
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	
//	NSLog(@"curDir=%@",documentsDirectory);
	NSError *error = nil;
	//NSString *filePath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/googleResponse.txt"];
	NSString *filePath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/"];
	
	filePath=[@"/Users/mingyou/Desktop/DAL" stringByAppendingPathComponent:fileName];
	NSLog(@"filePath=%@",filePath);
	return [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
}
+ (NSString *)readFromTextFile:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	if ([paths count]>0) {
		NSString *documentsDirectory = [paths objectAtIndex:0];    
		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName]; 
		NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];
		
		NSString *myString = [[NSString alloc] 
							  initWithBytes:[myData bytes] 
							  length:[myData length] 
							  encoding:NSUTF8StringEncoding];
		myData=nil;
	
		
		return myString;
	}
	else {
		return nil;
	}
}

//NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsDirectory = [docpaths objectAtIndex:0];
//NSDictionary *dataItem = [data objectAtIndex:indexPath.row];
//NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[dataItem objectForKey:@"Icon"]];
//cell.icon = [UIImage imageWithContentsOfFile:imagePath];

@end

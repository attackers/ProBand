//
//  XMLParsers.m
//  ColorBand
//
//  Created by admin on 15/4/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "XMLParsers.h"
@interface XMLParsers()<NSXMLParserDelegate>
{
    
}
@property (nonatomic, strong) NSMutableString *xmlstring;
@property (nonatomic, strong) NSMutableString *valueString;
@property (nonatomic, strong) NSString *xmlname;
@end
@implementation XMLParsers



-(void)parasexml
{
    self.xmlstring=[[NSMutableString alloc] init];
    self.valueString=[[NSMutableString alloc] init];
    NSError *error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"strings-1" ofType:@"xml"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
   
    if(error) {
        NSLog(@"Error %@", error);
    }
    // Create a parser and point it at the NSData object containing the file we just loaded
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    // Create an instance of our parser delegate and assign it to the parser
 
    [parser setDelegate:self];
    
    // Invoke the parser and check the result
    [parser parse];
    error = [parser parserError];
    if(error)
    {
        NSLog(@"xml Error %@", error);
        
    }

}

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
   // NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
   // NSLog(@"didStartElement --> %@", [attributeDict objectForKey:@"name"]);
    self.xmlname=[attributeDict objectForKey:@"name"];
    if (self.xmlname.length>0)
    [self.xmlstring appendString:[NSString stringWithFormat:@"\"%@\"=",self.xmlname]];
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   // NSLog(@"foundCharacters --> %@", string);
     if (self.xmlname.length>0)
     {
          //NSLog(@"foundCharacters --> %@", string);
     [self.valueString appendString:[NSString stringWithFormat:@"%@",string]];
     }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  
   // NSLog(@"didEndElement   --> %@", elementName);
      if (self.xmlname.length>0)
      {
       [self.xmlstring appendString:[NSString stringWithFormat:@"\"%@\";\n",self.valueString]];
      }
    [self.valueString setString:@""];
      self.xmlname=@"";
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"self.xmlstring=%@",[[self.xmlstring stringByReplacingOccurrencesOfString:@"  " withString:@""] stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\""]);
    
}

@end

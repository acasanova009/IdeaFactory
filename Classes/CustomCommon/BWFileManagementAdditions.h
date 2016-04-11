//
//  NSFileManager+myBWFileManagementAdditions.h
//  Premise
//
//  Created by Renato Casanova on 5/4/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinderControllerProtocols.h"

@interface NSFileManager (myBWFileManagementAdditions)


-(NSMutableArray*)enumerateDirectoryComponentsFromURL:(NSURL*)url;

-(NSMutableArray *)parseTextFileAt:(NSURL*)url;

-(id)readDataOfClass:(Class)class FromURL:(NSURL*)url;
-(BOOL)saveData:(id)data ToURL:(NSURL*)url;


-(NSMutableArray*)parseAllTextFilesAtUrlForBools:(NSArray*)currentBools;

-(void)updateRootKeysReferences:(NSMutableArray*)rootFile shouldAnimateRows:(UITableView*)tableView AndDelegate:(id <FinderArchiveReferenceProtocol>)referenceDelegate;

-(void)resetLocalizedDataBase;
-(void)resetLocalizedFactory;
@end

@interface NSMutableArray (differenceBetweenArrays)

+(NSMutableArray *)objectsFrom:(NSArray *)directoryFile thatAintHere:(NSArray *)rootFile;
+(NSMutableArray*)indexesOfObjectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile;

@end

@interface NSURL (myBWFileManagementAdditions)

+(NSURL*)URLsetUpFrom:(NSString*)afterBundle;

@end

@interface NSMutableDictionary (KeyManipulation)


-(void)exchangeOldKey:(NSString*)oldKey WithNewKey:(NSString*)newKey;

@end
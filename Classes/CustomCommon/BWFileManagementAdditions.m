
#import "BWFileManagementAdditions.h"
#import "AlertStrings.h"
#import "URLConst.h"

@implementation NSFileManager (myBWFileManagementAdditions)
-(void)resetLocalizedFactory
{

    
    NSURL * _bundle_Inital =  [[NSBundle mainBundle]URLForResource:@"Inital" withExtension:nil];
    
    NSError *error;
    NSURL *_library_Preferences = [NSURL URLsetUpFrom:urlLibaryPreferences];
    
    //    [self copyItemAtURL:_bundle_enligsh toURL:_documents_LocDatabse error:&error];
    
    NSArray * englishStuff = [self enumerateDirectoryComponentsFromURL:_bundle_Inital];
    for (NSString *file in englishStuff) {
        [self copyItemAtURL:[_bundle_Inital URLByAppendingPathComponent:file] toURL:[_library_Preferences URLByAppendingPathComponent:file] error:&error];
        if (error) {
            NSLog(@"error %@",[error description]);
        }
    }

}

-(void)resetLocalizedDataBase
{
   
    

    NSURL * _bundle_enligsh =  [[NSBundle mainBundle]URLForResource:@"English" withExtension:nil];
    
    NSError *error;
    NSURL *_documents = [NSURL URLsetUpFrom:urlDocuments];

    
    NSArray * englishStuff = [self enumerateDirectoryComponentsFromURL:_bundle_enligsh];
    for (NSString *file in englishStuff) {
            [self copyItemAtURL:[_bundle_enligsh URLByAppendingPathComponent:file] toURL:[_documents URLByAppendingPathComponent:file] error:&error];
        if (error) {
            NSLog(@"error %@",[error description]);
        }
    }

    

}

-(NSMutableArray *)parseTextFileAt:(NSURL*)url
{
    
    NSError * error;
    NSString * content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error at parsing text file: %@. With error: %@",[url lastPathComponent],[error description]);
        return [NSMutableArray array];
    }
    NSArray *parsed = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray* parsedM = [NSMutableArray arrayWithArray:parsed];
    NSMutableArray *deleteThis =[NSMutableArray arrayWithCapacity:parsedM.count];
    
    
    
    for (int i = 0; i <parsedM.count; i++) {
        
        
        
        parsedM[i] = [parsedM[i]capitalizedString];
        NSString *str =parsedM[i];
        
        
        
        
        
        if ([str isEqualToString:kEmptyText]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str hasPrefix:@" "]) {
            for (int b = 0; b < str.length; b++) {
                if ([str hasPrefix:@" "]) {
                    str = [str substringFromIndex:1];
                    parsedM[i] = str;
                }
                else
                {
                    break;
                }
            }
        }
        
        
        if ([str hasPrefix:@"("]) {
            if ( [str length] > 0)
                str = [str substringToIndex:1];
            parsedM[i] = str;
            
        }
        //Quitar la, el, los, ellos, whatever.
        if ([str hasPrefix:@"La "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;
            
        }
        if ([str hasPrefix:@"En "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;
            
        }
        if ([str hasPrefix:@"El "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;
            
        }
        if ([str hasPrefix:@"Una "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:3];
            parsedM[i] = str;
            
        }
        if ([str hasPrefix:@"Unos "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:4];
            parsedM[i] = str;
            
        }
        
        
        if ([str hasSuffix:@")"]) {
            if ( [str length] > 0)
                str = [str substringToIndex:[str length]-1];
            parsedM[i] = str;
            
        }
        if ([str isEqualToString:@"(to"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"("]) {
            [deleteThis addObject:str];
            
            continue;
        }
        
        if ([str isEqualToString:@"to"]) {
            [deleteThis addObject:str];
            continue;
        }
        
        if ([str isEqualToString:@"to)"]) {
            [deleteThis addObject:str];
            continue;
        }
        
        if ([str isEqualToString:@";"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"_"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"-"]) {
            [deleteThis addObject:str];
            continue;
        }
        
    }
    [parsedM removeObjectsInArray:deleteThis];
    
    return parsedM;
}
#pragma mark - REAL 

//REAL
-(NSMutableArray*)enumerateDirectoryComponentsFromURL:(NSURL*)url {
    
    NSMutableArray * mArray=[NSMutableArray array];

    NSDirectoryEnumerator * enumerator =[[NSFileManager defaultManager]enumeratorAtURL:url includingPropertiesForKeys:@[NSURLIsDirectoryKey,NSURLLocalizedNameKey] options:(NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsSubdirectoryDescendants) errorHandler:^(NSURL *url, NSError *error) {

        if (error) 
        NSLog(@"Error at loading text from Directory:  %@",[url lastPathComponent]);
        return YES;
    }];

    
    for (NSURL *temp in  enumerator) {
        if ([temp class] != [NSURL class]) {
            continue;
        }
            NSString *localizedName = nil;
            [temp getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
                    

            if ([localizedName hasSuffix:kTextSuffix] || [localizedName hasSuffix:@"saf"] || [localizedName hasSuffix:@"plist"] ) {
                [mArray addObject:localizedName];
            }
        


    }

    return mArray;
    
}
//REAL

-(NSMutableArray*)parseAllTextFilesAtUrlForBools:(NSArray*)currentBools;
{
    
    NSMutableArray * masterListOfConepts =[NSMutableArray array];

    
    NSURL * urlM =[NSURL URLsetUpFrom:urlDocuments];
    
    static BOOL haveOneSelectedList = NO;
    if (!currentBools)
        return nil;
    
    
    for (int i = 0; i< currentBools.count; i++) {
        
        
        NSArray* kind = currentBools[i];
        
//OLDNAVY
        
        if ([kind[0] boolValue] )
        {
        haveOneSelectedList =YES;
        NSArray * parsedText = [self parseTextFileAt:[urlM URLByAppendingPathComponent:kind[1]]];
        [masterListOfConepts insertObjects:parsedText atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, parsedText.count)]];
        }
        
    }
    if (!haveOneSelectedList) {
        
        return nil;
    }
    else
    {
        haveOneSelectedList =NO;
        return masterListOfConepts;
    }
}



-(void)updateRootKeysReferences:(NSMutableArray *)rootFile shouldAnimateRows:(UITableView *)tableView AndDelegate:(id<FinderArchiveReferenceProtocol>)referenceDelegate
{
    NSArray * directoryFile = [[NSFileManager defaultManager]enumerateDirectoryComponentsFromURL:[NSURL URLsetUpFrom:urlDocuments]];
    NSMutableArray *toCreate = [NSMutableArray objectsFrom:directoryFile thatAintHere:rootFile];
    
    if (toCreate.count > 0) {
        for (NSString* newReferenceString in toCreate) {

//OLDNAVY
            [rootFile insertObject:@[[NSNumber numberWithBool:NO],newReferenceString] atIndex:0];
            
            
            
            if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToCreateNewArchiveReference:)])
                [referenceDelegate finderControllerWantsToCreateNewArchiveReference:newReferenceString];

            
            if (tableView)
                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
    NSMutableArray *toDeleteIndexPaths = [NSMutableArray indexesOfObjectsFrom:directoryFile thatAintHere:rootFile];
    if (toDeleteIndexPaths.count > 0) {
        
        NSMutableArray *toDelete = [NSMutableArray array];
        for (int  i = 0;  i < toDeleteIndexPaths.count ; i++) {
            NSIndexPath * path = [toDeleteIndexPaths objectAtIndex:i];
            id kindToDelete = [rootFile objectAtIndex:path.row];
            [toDelete addObject:kindToDelete];
        }
        [rootFile removeObjectsInArray:toDelete];
        if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToDeleteArchiveReferences:)])
            [referenceDelegate finderControllerWantsToDeleteArchiveReferences:toDeleteIndexPaths];
        
        if (tableView)
            [tableView deleteRowsAtIndexPaths:toDeleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    }

    
    
}

#pragma mark

-(id)readDataOfClass:(Class)class FromURL:(NSURL*)url
{
    NSData *readArchive = [NSData  dataWithContentsOfURL:url];
    if (readArchive == NULL) {

        id data = [[class alloc]init];
        
        
        return data;
        
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:readArchive];
}
-(BOOL)saveData:(id)data ToURL:(NSURL*)url
{
    
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:data];
    return [archive writeToURL:url atomically:YES];
}

@end



#pragma mark - NSURL
@implementation NSURL (myBWFileManagementAdditions)

+(NSURL*)URLsetUpFrom:(NSString*)afterBundle

{

    NSURL* url =[[[[NSBundle mainBundle]bundleURL] URLByDeletingLastPathComponent]URLByAppendingPathComponent:afterBundle];

    NSFileManager *manager= [NSFileManager defaultManager];
    NSError *error;

    [manager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        //Hanlde error
        NSLog(@"Error at creating directories at %@",url);
    }
    return url;
}

@end

#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (KeyManipulation)

-(void)exchangeOldKey:(NSString*)oldKey WithNewKey:(NSString*)newKey
{
    id value = [self objectForKey:oldKey];
    [self removeObjectForKey:oldKey];
    [self setValue:value forKey:newKey];
}

@end


#pragma mark - NSMutableArray
@implementation NSMutableArray (differenceBetweenArrays)

//OLDNAVY
+(NSMutableArray*)indexesOfObjectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile
{
    NSMutableArray * indexesToDelete = [NSMutableArray array];
    for (NSArray* keysObjects  in rootFile) {
        NSString* keyString = keysObjects[1];
        BOOL inDirectoryFile =NO;
        for (NSString* directoryObject in directoryFile) {


            
            if ([keyString isEqualToString:directoryObject]) {
                inDirectoryFile =YES;
                break;
            }
        }
        if (!inDirectoryFile) {

            NSIndexPath * path = [NSIndexPath  indexPathForItem:[rootFile indexOfObject:keysObjects] inSection:0];
            [indexesToDelete addObject:path];
            
        }
    }
    return indexesToDelete;
}
+ (NSMutableArray *)objectsFrom:(NSArray *)directoryFile thatAintHere:(NSArray *)keysFile
{
    NSMutableArray *toCreate = [NSMutableArray array];

    for (id dirrectoryObject in directoryFile) {

        BOOL isThisNew = YES;
        for (id keysObject in keysFile)
        {
//OLDNAVY
            if ([keysObject[1] isEqual:dirrectoryObject]) {
                
                isThisNew = NO;
                break;
            }
        }
        if (isThisNew) {
            [toCreate addObject:dirrectoryObject];

        }
    }
    return toCreate;
}
@end
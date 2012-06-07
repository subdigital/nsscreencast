//
//  UA_ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "UA_zip.h"
#include "UA_unzip.h"

@protocol UA_ZipArchiveDelegate <NSObject>
@optional
-(void) ErrorMessage:(NSString*) msg;
-(BOOL) OverWriteOperation:(NSString*) file;

@end


@interface UA_ZipArchive : NSObject {
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	id			_delegate;
}

@property (nonatomic, retain) id delegate;

-(BOOL) CreateZipFile2:(NSString*) zipFile;
-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
-(BOOL) CloseZipFile2;

-(BOOL) UnzipOpenFile:(NSString*) zipFile;
-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL) UnzipCloseFile;
@end

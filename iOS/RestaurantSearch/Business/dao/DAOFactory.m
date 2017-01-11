//
//  DAOFactory.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2014 Artur Felipe. All rights reserved.. All rights reserved.
//

#import "DAOFactory.h"
#import "DatabaseManager.h"

@implementation DAOFactory

+ (void)configDatabaseManager
{
    NSURL *pathModel = DB_MODEL_URL;
    
#ifdef DEBUG
    NSURL *pathDb =  DB_STOREPATH_URL;
#else
    NSURL *pathDb = DB_STOREPATH_LIGHT_URL;
#endif
    
    
    if(TARGET_IPHONE_SIMULATOR){
        pathDb =  DB_STOREPATH_DESKTOP_TEST;
        
        NSError *error;
        
        [self deleteDatabaseAtFirstRun];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[pathDb relativePath]])
        {
            [[NSFileManager defaultManager] copyItemAtPath:DB_STOREPATH_BUNDLE_DB toPath:[pathDb relativePath] error:&error];
        }
    }
    else{
        NSError *error;
        
        [self deleteDatabaseAtFirstRun];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:DB_STOREPATH])
        {
#ifdef DEBUG
            NSString *dbOriginPath = DB_STOREPATH_BUNDLE_DB;
#else
            NSString *dbOriginPath = DB_STOREPATH_LIGHT_BUNDLE_DB;
#endif
            
            [[NSFileManager defaultManager] copyItemAtPath:dbOriginPath toPath:DB_STOREPATH error:&error];
        }
    }
    
    [[DatabaseManager sharedInstance] setDataModelURL:pathModel];
    [[DatabaseManager sharedInstance] setStorePath:pathDb];
}

+ (void)deleteDatabaseAtFirstRun{
    NSError *error;
    
    BOOL alreadyDeleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"deleteDatabaseIfFirstRun"];
    
    if (!alreadyDeleted) {
        if(TARGET_IPHONE_SIMULATOR){
            [[NSFileManager defaultManager] removeItemAtPath:[DB_STOREPATH_DESKTOP_TEST relativePath] error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:DB_STOREPATH_DESKTOP_TEST_SHM error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:DB_STOREPATH_DESKTOP_TEST_WAL error:&error];
        }
        else{
            [[NSFileManager defaultManager] removeItemAtPath:DB_STOREPATH error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:DB_STOREPATH_SHM error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:DB_STOREPATH_WAL error:&error];
        }
        
        [[DatabaseManager sharedInstance] reset];        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteDatabaseIfFirstRun"];
    }
}

+ (void)configDatabaseManagerForInstance:(DatabaseManager *)instance
{
    NSURL *pathModel = DB_MODEL_URL;
#ifdef DEBUG
    NSURL *pathDb = DB_STOREPATH_URL;
#else
    NSURL *pathDb = DB_STOREPATH_LIGHT_URL;
#endif
    
    if(TARGET_IPHONE_SIMULATOR){
        pathDb =  DB_STOREPATH_DESKTOP_TEST;
        
        NSError *error;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[pathDb relativePath]])
        {
            [[NSFileManager defaultManager] copyItemAtPath:DB_STOREPATH_BUNDLE_DB toPath:[pathDb relativePath] error:&error];
        }
    }
    else{
        NSError *error;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:DB_STOREPATH])
        {
            [[NSFileManager defaultManager] copyItemAtPath:DB_STOREPATH_BUNDLE_DB toPath:DB_STOREPATH error:&error];
        }
    }
    
    [instance setDataModelURL:pathModel];
    [instance setStorePath:pathDb];
}

@end

//
//  Constants.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 11/15/14.
//  Copyright © 2014 Artur Felipe. All rights reserved.
//

#define DEBUG 1

//Abstract class simulation
#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]


#define ICLOUD_DATABASE_CONFIGURATION_PATH @"Database"
#define ICLOUD_DATABASE_CONFIGURATION_FILE_NAME @"/database.bkp"
#define ICLOUD_DATABASE_CONFIGURATION_FULL_PATH_FILE_NAME [NSString stringWithFormat:@"%@%@",ICLOUD_DATABASE_CONFIGURATION_PATH, ICLOUD_DATABASE_CONFIGURATION_FILE_NAME]

#define ICLOUD_DEFAULTS_CONFIGURATION_PATH @"UserDefaults"
#define ICLOUD_DEFAULTS_CONFIGURATION_FILE_NAME @"/UserDefaultsCloudSettings.data"
#define ICLOUD_DEFAULTS_CONFIGURATION_FULL_PATH_FILE_NAME [NSString stringWithFormat:@"%@%@",ICLOUD_DEFAULTS_CONFIGURATION_PATH, ICLOUD_DEFAULTS_CONFIGURATION_FILE_NAME]

#define ICLOUD_CONTAINER_IDENTIFIER @"iCloud.com.arturfelipe.RestaurantSearch"

//Timeout
#define DEFAULT_REST_TIMEOUT                            60

//Error codes
#define ERROR_COREDATA_CONTEXT_NIL                      1000

#define ERROR_RESTCLIENT_WRAPPER                        1001

#define ERROR_DATABASEMANAGER_FETCH_ENTITY_NIL          1002
#define ERROR_DATABASEMANAGER_FETCH_CONTEXT_NIL         1003
#define ERROR_DATABASEMANAGER_FETCH_CATCH               1004

#define ERROR_DATABASEMANAGER_CREATE_CATCH              1005
#define ERROR_DATABASEMANAGER_CREATE_ENTITY_NIL         1006
#define ERROR_DATABASEMANAGER_CREATE_CONTEXT_NIL        1007

#define ERROR_DATABASEMANAGER_DELETE_CONTEXT_NIL        1008

#define ERROR_BASEDAO_NO_RESULTS                        1009


locals {
    dns_records = [{
        name                = "api"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.no"
        ttl                 = "3600"
        records             = ["10.96.10.21"]
    },
    {  
        name                = "management"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.no"
        ttl                 = "3600"
        records             = ["10.96.10.21"]
    },
    {
        name                = "portal"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.no"
        ttl                 = "3600"
        records             = ["10.96.10.21"]
    }]
}
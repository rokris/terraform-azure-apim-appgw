locals {
    dns_records = [{
        name                = "api"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.com"
        ttl                 = "300"
        records             = ["10.96.10.20"]
    },
    {  
        name                = "management"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.com"
        ttl                 = "300"
        records             = ["10.96.10.20"]
    },
    {
        name                = "portal"
        resource_group_name = "ng-ti-test-rokris-rg"
        zone_name           = "snorkelground.com"
        ttl                 = "300"
        records             = ["10.96.10.20"]
    }]
}
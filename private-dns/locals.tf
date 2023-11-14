locals {
  dns_records = [{
    name                = "api"
    resource_group_name = "ng-ti-test-rokris-rg"
    zone_name           = "azure-api.net"
    ttl                 = "300"
    },
    {
      name                = "management"
      resource_group_name = "ng-ti-test-rokris-rg"
      zone_name           = "azure-api.net"
      ttl                 = "300"
    },
    {
      name                = "portal"
      resource_group_name = "ng-ti-test-rokris-rg"
      zone_name           = "azure-api.net"
      ttl                 = "300"
  }]
}
---
title: "ATG Repository item linking and versioned repos"
date: 2013-03-10T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["atg","ecommerce"]
author: "Miro Adamy"
---


We have versioned repository ClientProvinceRepository that defines discount types based on account category pricelist and accounts - discountTypePriceList

=> (let's not start discussion why this is not part of the pricelists).

The item definition:

```
<item-descriptor name="discountTypePriceList" display-name="Discount Type Price List" item-cache-size="1000" query-cache-size="1000" display-property="discountType">
    <table name="CPLXB2B_DISCOUNT_PRICE_LIST" type="primary" id-column-name="DISCOUNT_PRICELIST_ID" >
        <property name="discountType" data-type="enumerated" column-name="DISCOUNT_TYPE" default="Base" queryable="true" category="Discount Price List" display-name="Discount Type" >
              <attribute name="useCodeForValue" value="false"/>
                  <option value="Base" code="0"/>
                <option value="Silver" code="1"/>
                <option value="Gold" code="2"/>
                <option value="Platinum" code="3"/>
        </property>
        <property name="priceListId" column-name="PRICE_LIST_ID"  repository="/atg/commerce/pricing/priceLists/PriceLists" item-type="priceList" display-name="List Price List" required="true" category="Discount Price List"/>
        <property name="salePriceListId" column-name="SALE_PRICE_LIST_ID"  repository="/atg/commerce/pricing/priceLists/PriceLists" item-type="priceList" display-name="Sale Price List" category="Discount Price List"/>
        <property name="startDate" column-name="START_DATE" data-type="timestamp" display-name="Start Date" category="Discount Price List"/>
        <property name="endDate" column-name="END_DATE" data-type="timestamp" display-name="End Date" category="Discount Price List"/>
    </table>
     
</item-descriptor>
```

When I tried deployment with this, I got error

```
13:39:28,476 INFO  [DeploymentManager] The property named priceListId in the /client/b2b/commerce/province/repository/clientProvinceRepository_production repository has a reference to another repository /atg/commerce/pricing/priceLists/PriceLists. Be sure that the foreign property reference is configured correctly in the destination repository. The reference needs to point to the mapped destination repository and not the repository that is mapped in the source.
13:39:28,478 ERROR [DeploymentManager]
atg.repository.RepositoryException: A repository misconfiguration has been detected. The property named priceListId in the /client/b2b/commerce/province/repository/clientProvinceRepository_production destination repository has a reference to source repository /atg/commerce/pricing/priceLists/PriceLists. This property has a reference to a foreign repository which should be configured to a destination repository and not a source repository.
        at atg.deployment.repository.ReferenceItemGenerator.generateDummyItems(ReferenceItemGenerator.java:254)
        at atg.deployment.repository.RepositoryWorkerThread.preDeploymentPhase(RepositoryWorkerThread.java:536)
        at atg.deployment.DeploymentWorkerThread.run(DeploymentWorkerThread.java:310)
13:39:28,499 ERROR [DeploymentManager]  item = null cause = atg.repository.RepositoryException: A repository misconfiguration has been detected. The property named priceListId in the /client/b2b/commerce/province/repository/clientProvinceRepository_production destination repository has a reference to source repository /atg/commerce/pricing/priceLists/PriceLists. This property has a reference to a foreign repository which should be configured to a destination repository and not a source repository.
        at atg.deployment.repository.ReferenceItemGenerator.generateDummyItems(ReferenceItemGenerator.java:254)
        at atg.deployment.repository.RepositoryWorkerThread.preDeploymentPhase(RepositoryWorkerThread.java:536)
        at atg.deployment.DeploymentWorkerThread.run(DeploymentWorkerThread.java:310)
 message = An error occurred during the pre-deployment phase time = 2013-03-09  atg.deployment.DeploymentFailure@30b36590
```

What this means (in my interpretation) is that in MGMT node the `/atg/commerce/pricing/priceLists/PriceLists` is actually source repo (versioned), and the destination is `/atg/commerce/pricing/priceLists/PriceLists_production`.

I added the following to the MGMT configuration - replaced the item descriptor with references to non-versioned repository `/client-ca/config/client/b2b/commerce/province/repository/clientProvinceRepository.xml`

```
<item-descriptor name="discountTypePriceList" display-name="Discount Type Price List" item-cache-size="1000" query-cache-size="1000" display-property="discountType" xml-combine="replace">
    <table name="CPLXB2B_DISCOUNT_PRICE_LIST" type="primary" id-column-name="DISCOUNT_PRICELIST_ID" >
        <property name="discountType" data-type="enumerated" column-name="DISCOUNT_TYPE" default="Base" queryable="true" category="Discount Price List" display-name="Discount Type" >
              <attribute name="useCodeForValue" value="false"/>
                  <option value="Base" code="0"/>
                <option value="Silver" code="1"/>
                <option value="Gold" code="2"/>
                <option value="Platinum" code="3"/>
        </property>
        <property name="priceListId" column-name="PRICE_LIST_ID"  repository="/atg/commerce/pricing/priceLists/PriceLists_production" item-type="priceList" display-name="List Price List" required="true" category="Discount Price List" />
        <property name="salePriceListId" column-name="SALE_PRICE_LIST_ID"  repository="/atg/commerce/pricing/priceLists/PriceLists_production" item-type="priceList" display-name="Sale Price List" category="Discount Price List"/>
        <property name="startDate" column-name="START_DATE" data-type="timestamp" display-name="Start Date" category="Discount Price List"/>
        <property name="endDate" column-name="END_DATE" data-type="timestamp" display-name="End Date" category="Discount Price List"/>
    </table>
     
</item-descriptor>
```

This allowed the deployement to go through, however, now I see these in log file during deployment:


```
19:48:54,966 INFO  [DeploymentManager] The property named priceListId in the /client/b2b/commerce/province/repository/clientProvinceRepository_production repository has a reference to another repository /atg/commerce/pricing/priceLists/PriceLists_production. Be sure that the foreign property reference is configured correctly in the destination repository. The reference needs to point to the mapped destination repository and not the repository that is mapped in the source.
19:48:54,966 INFO  [DeploymentManager] The property named priceListId in the /client/b2b/commerce/province/repository/clientProvinceRepository_production versioned repository references the unversioned repository  /atg/commerce/pricing/priceLists/PriceLists_production. Verify that all the data in the unversioned repository exists on the target server, otherwise deployments which reference this data will fail.
```

### Questions

1. How serious is the message ?
2) Is there better way ?
3) If yes, what is proper way to deal with this (other than moving the item to pricelists repo ?)

 
### Note

As Joel pointed out (thanks), I have checked the `RepositoryMapper` and found that client does not have one.

This is how it is configured in client2:

```
Users/miro/src/TWC/client2/Management/config/atg/repository/ProductionRepositoryMapper.properties:
    1: repositoryMappings+=\
    2  /client2/repository/ContentRepository=/client2/repository/ContentRepository_production,\
    3  /client2/repository/OperationsRepository=/client2/repository/OperationsRepository_production
``` 

All client has is the OOTB values in this, no custom repos were (ever) added.

This guide <http://docs.oracle.com/cd/E23507_01/Platform.20073/ATGBCCAdminGuide/html/s0203configuringforeignrepositoryrefe01.html> explains what and hows. 
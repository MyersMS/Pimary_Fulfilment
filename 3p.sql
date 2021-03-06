#!/usr/bin/sql

SELECT		
	DISTINCT sa.id "SAID",	
	sa.parentrecordid "WOID",	
	sa.contact_email__c "Email",	
	CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) "SA Sch ST",	
	sa.schedstarttimelocal__c "SA Sch STL",        	
	wt.name "Work Type",	
	wo.status "WO Status",	
	sa.status "App Status",	
	st.description "Actual Fulfillment Warehouse",	
	sa.toplevelterritoryname__c "FSL Warehouse",	
	st.name "FSL Zone Name",	
	sa.postalcode "FSL Postal",	
	sr.name "Van Name",	
	sr.resource_provider__c "Usual Van Provider"	
		
	--s.pk "Shipment",	
	--woli.cms_short_shipment_id__c "Short Shipment Id",	
	--s.order_id,	
	--sa.id "ServiceAppointment ID",	
	--s.delivery_status "CMS Shipment Status",	
	--DATE(sa.schedstarttime) "FSL Scheduled Date",	
	--DATE(wo.createddate) "FSL Created Date",	
	--o.shipping_postal_code "CMS Order Postal",	
	--nl.full_name "Correct NS Location",	
	--nl.location_id "Correct NS Location ID",	
	--nl2.full_name "Current NS Location",	
	--nl2.location_id "Current NS Location ID",	
		
FROM 		
	ods_ecomm_hourly.shipment s	
		
	RIGHT JOIN 	
		sd_salesforce2_fieldservice.serviceappointment sa ON s.partner_work_order_id = sa.parentrecordid
	RIGHT JOIN 	
		sd_salesforce2_fieldservice.serviceresource sr ON sa.service_resource_name__c = sr.name
	INNER JOIN	
		sd_salesforce2_fieldservice.serviceterritory st ON sa.serviceterritoryid = st.id
	LEFT JOIN 	
		sd_salesforce2.workorder wo ON wo.id = sa.parentrecordid
	INNER JOIN 	
		sd_salesforce2_fieldservice.worktype wt ON sa.worktypeid = wt.id
	LEFT JOIN	
		sd_salesforce2_fieldservice.workorderlineitem woli ON woli.workorderid = wo.id
	LEFT JOIN	
		sd2_ecomm_realtime.peloton_order o ON s.order_id = o.pk
	RIGHT JOIN	
		ods_ecomm_daily.postalcode pc ON pc.code = sa.postalcode AND pc.country = sa.countrycode
	INNER JOIN 	
		ods_ecomm_daily.warehouse w ON pc.warehouse_id = w.pk
	INNER JOIN 	
		sd_salesforce2_fieldservice.operatinghours oh ON st.operatinghoursid = oh.id
		
	--LEFT JOIN 	
		--netsuite.locations nl ON st.description = nl.ecomm_slug
	--RIGHT JOIN 	
		--netsuite.locations nl2 ON nl2.ecomm_slug = w.code
		
WHERE		
		CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-06-29')
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-01-28') -- Cranberry
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-02-11') --Hazelwood
	AND	
		CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-06-30')
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-01-29') -- Cranberry
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-02-12') --Hazelwood
	AND 	
		st.name LIKE '%waukegan%'
		--st.name LIKE '%cranberry%'
		--st.name LIKE '%hazelwood%'
		
	--AND 	
		--sa.parentrecordid IN ('')
	--AND 	
		--wo.status NOT IN ('Canceled')
	--AND 	
		--sa.status NOT IN ('Canceled','Cannot Complete','Reschedule')
	--AND 	
		--sa.countrycode IN ('US')
	--AND 	
		--sa.schedstarttime >= DATEADD(Day ,-6, current_date)
	--AND	
		--nl.location_id != nl2.location_id
	--AND	
		--sa.toplevelterritoryname__c IN(
		--'Chicago',
		--'Cincinnati - Dayton',
		--'Cleveland - Brooklyn Heights',
		--'Detroit - Southfield',
		--'Minneapolis',
		--'Pittsburgh - Cranberry Township',
		--'St. Louis - Hazelwood',
		--'Toronto - Vaughan',
		--'Chicago - Waukegan')
	--AND 	
		--w.partner_flag = 'peloton-fsl'
	--AND	
		--(wo.fulfilled_by_dfos__c = 'TRUE' OR sr.resource_provider__c LIKE '%DFOS' OR sr.name LIKE 'HELP%' OR sr.name LIKE '%DFOS%')
		
--ORDER BY 		
	--"FSL Scheduled Date" ASC, "FSL Warehouse" ASC	

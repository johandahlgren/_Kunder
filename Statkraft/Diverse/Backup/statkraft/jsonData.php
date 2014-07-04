<?php
	header("Access-Control-Allow-Origin: *");
	header('Content-Type: application/javascript');
?>
<?php print $_REQUEST["callback"] ?> ({
    "HousholdSupplies": [
		{
			"CountryCode": "NO",
			"NumberOfHouseholdsSupplyNow": 42731.67844103801
		},
		{
			"CountryCode": "SE",
			"NumberOfHouseholdsSupplyNow": 74384.77358254764
		},
		{
			"CountryCode": "UK",
			"NumberOfHouseholdsSupplyNow": 157520.69699833618
		}
	],
	"MarkedValues": [
		{
			"Code": "NO",
			"MWhisWorthInEuro": 38.66
		},
		{
			"Code": "SE",
			"MWhisWorthInEuro": 63.66
		},
		{
			"Code": "UK_ONSHORE",
			"MWhisWorthInEuro": 138.66
		},
		{
			"Code": "UK_OFFSHORE",
			"MWhisWorthInEuro": 88.66
		}
	],
	"WindParks": [
		{
			"AccumulatedProductionMWhPreviousDay": 10.4808333650128,
			"AccumulatedProductionMWhPreviousYear": 265.5249749772229,
			"AccumulatedProductionMWhThisDay": 10.4808333650128,
			"AvailabilityFactor": 0.9852941176470589,
			"CapacityFactor": 0.004181183523276383,
			"CountryCode": "NO",		
			"DataQualityIndicator": 1,
			"Latitude": 63.3566,
			"Longitude": 8.03422,
			"MaxCapacityMW": 150.4,
			"Name": "Smøla",
			"TimeStampInUtc": "/Date(1381927200000+0200)/",
			"TotalProductionMWNow": 0.000628850001900768,
			"WindSpeed10MinuteAverageMeterPerSecond": 6.21316662828127
		},
		{
			"AccumulatedProductionMWhPreviousDay": 38.118055542309996,
			"AccumulatedProductionMWhPreviousYear": 202.1759415814286,
			"AccumulatedProductionMWhThisDay": 38.118055542309996,
			"AvailabilityFactor": 0.9583333333333334,
			"CapacityFactor": 0.04143266906772826,
			"CountryCode": "NO",		
			"DataQualityIndicator": 1,
			"Latitude": 63.56438,
			"Longitude": 8.74416,
			"MaxCapacityMW": 55.2,
			"Name": "Hitra",
			"TimeStampInUtc": "/Date(1381927200000+0200)/",
			"TotalProductionMWNow": 0.0022870833325386,
			"WindSpeed10MinuteAverageMeterPerSecond": 3.39800000588099
		},
		{
			"AccumulatedProductionMWhPreviousDay": 31.736666561828663,
			"AccumulatedProductionMWhPreviousYear": 52.894244435303854,
			"AccumulatedProductionMWhThisDay": 31.736666561828663,
			"AvailabilityFactor": 1,
			"CapacityFactor": 0.06543642590067766,
			"CountryCode": "NO",
			"DataQualityIndicator": 1,
			"Latitude": 69.82684,
			"Longitude": 21.9692,
			"MaxCapacityMW": 29.1,
			"Name": "Kjøllefjord",
			"TimeStampInUtc": "/Date(1381927200000+0200)/",
			"TotalProductionMWNow": 0.00190419999370972,
			"WindSpeed10MinuteAverageMeterPerSecond": 3.28449999411901
		}
	]
});
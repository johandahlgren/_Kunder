<script charset="utf-8">
		function spaceit(fixthis){
			var c = fixthis.split(',');
			var f = "";
			for(var i=0;i<c.length;i++){
				if(i!==0){
					f=f+", "+c[i];
				}else{
					f = c[i];
				}
			}
			return f;
		}
		$.ajax({
	        type: "get",
			url: "proxy.php?csurl=http://www.vasttrafik.se/external_services/TrafficInformation.asmx/GetAllValidItems?identifier=",
			dataType: "xml",
			success: function(xml) {
				$(xml).find('string').each(function(){
					var xmlDoc = $.parseXML(decodeURIComponent($(this).text())),
					$xml2 = $(xmlDoc);
					$xml2.find('item').each(function(){
						
						$('#traficSituation').append('<li id="'+$(this).attr('id')+'">'+	
													'<h3>'+$(this).find('title').text()+'</h3>'+
													'<p>id:'+$(this).attr('id')+'</p>'+
													'<p>priority_code:'+$(this).attr('priority_code')+'</p>'+
													'<p>priority:'+$(this).attr('priority')+'</p>'+
													'<p>valid_date_from:'+$(this).attr('valid_date_from')+'</p>'+
													'<p>valid_date_to:'+$(this).attr('valid_date_to')+'</p>'+
													'<p>publish_date_from:'+$(this).attr('publish_date_from')+'</p>'+
													'<p>publish_date_to:'+$(this).attr('publish_date_to')+'</p>'+
													'<p>area_codes:'+$(this).attr('area_codes')+'</p>'+
													'<p>lines:'+spaceit($(this).attr('lines'))+'</p>'+
													'<p>county:'+spaceit($(this).attr('county'))+'</p>'+
													'<p>changed:'+$(this).attr('changed')+'</p>'+
													'<p>created:'+$(this).attr('created')+'</p>'+
													'<p>'+$(this).text()+'</p>'+
													'</li>');
					});
				});
			}
		});
		</script>
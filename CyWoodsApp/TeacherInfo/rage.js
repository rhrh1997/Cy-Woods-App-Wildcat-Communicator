var script = document.createElement( 'script' );
script.type = 'text/javascript';
script.src = "http://code.jquery.com/jquery-1.9.0.js";
$("head").append( script );

var ar = $(".CollapsiblePanel");
var str = "(";
for(var i = 0; i<ar.length; i++){
	var dep = $(ar[i]).find(".CollapsiblePanelTab");
	var name = (dep.text().trim());
	var a2 = $(ar[i]).find("tr");
	
	str += "{\n\"dep\"=\"" + name + "\";\n";
	str += "\"ar\"=(\n";
	for(var j = 0; j<a2.length; j++){
		var ahr = $(a2[j]).find("a");
		var tname = $(ahr[0]).text();
		var email = $(ahr[0]).attr("href");
        var desc = $($(a2[j]).find(".CollapsiblePanelContent")[1]);
		email = email.substring("mailto:".length);
		var site = $(ahr[1]).attr("href");
		if( site != null)
			site = site.substring("/web/20130214195820/".length);
		console.log(name + "|" + tname + "|" + email + "|" + site + "|"+desc.text());
		str += "{\n\"name\"=\""+tname+"\";\n\"email\"=\""+email+"\";\n\"site\"=\""+site+"\";\n}";
		if( j!= a2.length-1) str += ",";
	}
	str += ");\n";
	str += "},\n";
}
str += ")";
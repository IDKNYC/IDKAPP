var jsonobj = [
 {key1: value1},
 {key2: value2},
 {key3: value3}
 ]

for( var i =0; i < jsonobj.length; i++){
    for( var j in jsonobj[i]) {
        if( j == "name") {
            var nameString = jsonobj[i][j];
        }
    }
}


var parsedObj = JSON.stringfy( result );

for( var i =0; i < parsedObj.length; i++){
    for( var j in parsedObj[i]) {
        if( j == "name") {
            var nameString = parsedObj[i][j];
        }
    }
}
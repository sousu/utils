// 文字操作 
function println(s){
    WScript.echo(s);
}
function print(s){
    WScript.StdOut.Write(s);
}
function printHeader(s){
    var len = 50;
    var join = function(s,n){
        var r = [];
        for(var i=n;--i>=0;) r.push(s);
        return r.join('');
    }
	WScript.echo("=== "+s+" "+join("=",len-s.length));
}
if(!String.prototype.repeat){
    String.prototype.repeat = function(count){
        return Array(count*1+1).join(this);
    };
}
// 時刻
function now(){
    var date = new Date();
    var y = date.getYear();
    var m = date.getMonth()+1;
    var d = date.getDate();
    var hour = date.getHours();
    var minuite = date.getMinutes();
    var sec = date.getSeconds();
    if(m < 10) m = '0' + m; 
    if(d < 10) d = '0' + d; 
    if(hour < 10) hour = '0' +hour; 
    if(minuite < 10) minuite = '0' +minuite;
    if(sec < 10) sec = '0' +sec;
    var n = y + "/" + m + "/" + d + " " + hour + ":" + minuite + ":" + sec;
    return n;
}
// ファイル操作 
function eachFile(path,func){
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    var files = fs.GetFolder(path).Files;
    var e = new Enumerator(files);
    for ( ; !e.atEnd(); e.moveNext()){
        func(e.item(),path+"/"+e.item().name);
    }
}
function moveForce(src,dest){
    var fs = new ActiveXObject( "Scripting.FileSystemObject" );
    fs.CopyFile(src,dest,true); //上書き
    fs.DeleteFile(src);
}
function getFullName(path){
    dir = String(WScript.ScriptFullName).replace(WScript.ScriptName,"");
    return dir+path;
}
// フォルダ操作
function makeFolder(path){
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    if(fs.FolderExists(path)){
    }else{
        fs.CreateFolder(path);
    }
}
function cd(){
    var fso    = WScript.CreateObject("Scripting.FileSystemObject");
    var wshell = WScript.CreateObject("WScript.Shell");
    wshell.CurrentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder.Path;
}

// --- test ---
//printHeader("test");
//println(now());


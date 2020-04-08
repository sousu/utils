// 文字操作 
function println(s){
	WScript.echo(s);
}
function print(s){
    WScript.StdOut.Write(s);
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
// フォルダ操作
function makeFolder(path){
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    if(fs.FolderExists(path)){
    }else{
        fs.CreateFolder(path);
    }
}

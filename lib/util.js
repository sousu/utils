// �������� 
function println(s){
	WScript.echo(s);
}
function print(s){
    WScript.StdOut.Write(s);
}
// �t�@�C������ 
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
    fs.CopyFile(src,dest,true); //�㏑��
    fs.DeleteFile(src);
}
// �t�H���_����
function makeFolder(path){
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    if(fs.FolderExists(path)){
    }else{
        fs.CreateFolder(path);
    }
}

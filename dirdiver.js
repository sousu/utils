//
// DirDiv: dir enumrater
//
if(!String.prototype.repeat){
   String.prototype.repeat = function(count){
      return Array(count*1+1).join(this);
   };
}
function println(s){
    WScript.echo(s);
}
function DirDiver(){
    var fsys = WScript.CreateObject("Scripting.FileSystemObject");
    var dir,file,depth,curLv,regex,exregex;
    var funcPre,funcFirstChild,funcLastChild,funcLast;
    var curPath = "";

    this.setDir = function(dirPath,depth){
        this.dir = fsys.GetFolder(dirPath);
        this.curPath = dirPath;
        depth ? this.depth = depth : this.depth = 10;
    }
    this.setDepth = function(depth){
        this.depth = depth;
    }
    this.setFunc = function(type,func){
        switch(type){
            case 'pre' : this.funcPre = func; break;
            case 'firstchild': this.funcFirstChild = func; break;
            case 'lastchild' : this.funcLastChild = func; break;
            case 'last' : this.funcLast = func; break;
            case 'file' : this.funcFile = func; break;
            default : break;
        }
    }
    this.setRegex = function(regex,exregex){
        this.regex = regex;
        this.exregex = exregex;
    }
    this.dive = function(){
        this.enumDir(this.dir,this.curPath,0);
    }
    this.enumDir = function(folderObj,curPath,curLv){
        if(this.depth && curLv > this.depth) return;
        if(curLv != 0 && !match(curPath,this.regex,this.exregex)) return;
        var hasChild = false;
        this.dir = folderObj;
        this.curPath = curPath;
        this.curLv = curLv;
        if(this.funcPre) this.funcPre(this); //フォルダへ実行
        var files = fsys.GetFolder(curPath).Files;
        var files = new Enumerator(files);
        for (; !files.atEnd(); files.moveNext()) {
            this.file = files.item();
            if(this.funcFile) this.funcFile(this); //ファイルへ実行
        }
        var subfolders = new Enumerator(folderObj.SubFolders);
        for (; !subfolders.atEnd(); subfolders.moveNext()) {
            if(this.depth && curLv+1 > this.depth) break;
            if(!hasChild && this.funcFirstChild) this.funcFirstChild(this); //サブフォルダ検出時実行
            hasChild = true;
            var name = subfolders.item().Name;
            this.enumDir(subfolders.item(),curPath+'\\'+name,curLv+1);
        }
        this.dir = folderObj;
        this.curPath = curPath;
        this.curLv = curLv;
        if(hasChild && this.funcLastChild) this.funcLastChild(this); //サブフォルダ走査後に実行
        if(this.funcLast) this.funcLast(this); //フォルダの最後に実行
    }
    function match(str,regex,exregex){
        var m = true;
        if(regex){ re = new RegExp(regex); if(!re.test(str)) m = false; }
        if(exregex){ re = new RegExp(exregex); if(re.test(str)) m = false; }
        return m;
    }
}

// --- main ---
var dd = new DirDiver();
dd.setDir('c:\\',3);
dd.setFunc('pre',function(d){
    println("  ".repeat(d.curLv-1)+d.curLv+":"+d.dir.name);
});
dd.setFunc('file',function(d){
    var dla = new Date(d.file.DateLastAccessed);
    println("  ".repeat(d.curLv)+d.curPath+"\\"+d.file.name+"\t"+dla.toString());
});
dd.setRegex(/tool/);
dd.dive();



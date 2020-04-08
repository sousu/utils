' --- ---
' GUI呼出
' --- ---

Function vbInput(title,msg,def)
    vbInput = InputBox(msg,title,def)
End Function

Function vbSelectFile()
    Option Explicit
    On Error Resume Next
    Dim objShell    'Shellオブジェクト
    Dim objFolder   'フォルダ情報

    Set objShell = WScript.CreateObject("Shell.Application")
    If Err.Number = 0 Then
        Set objFolder = objShell.BrowseForFolder(0, "通常", 0)
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
        Set objFolder = objShell.BrowseForFolder(0, "Ｃドライブ", 0, "C:\")
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
        Set objFolder = objShell.BrowseForFolder(0, "スタートメニュー", 0, &HB)
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
    Else
        WScript.Echo "エラー：" & Err.Description
    End If

    Set objFolder = Nothing
    Set objShell = Nothing
End Function



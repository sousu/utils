' --- ---
' GUI�ďo
' --- ---

Function vbInput(title,msg,def)
    vbInput = InputBox(msg,title,def)
End Function

Function vbSelectFile()
    Option Explicit
    On Error Resume Next
    Dim objShell    'Shell�I�u�W�F�N�g
    Dim objFolder   '�t�H���_���

    Set objShell = WScript.CreateObject("Shell.Application")
    If Err.Number = 0 Then
        Set objFolder = objShell.BrowseForFolder(0, "�ʏ�", 0)
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
        Set objFolder = objShell.BrowseForFolder(0, "�b�h���C�u", 0, "C:\")
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
        Set objFolder = objShell.BrowseForFolder(0, "�X�^�[�g���j���[", 0, &HB)
        If Not objFolder Is Nothing Then
            WScript.Echo objFolder.Items.Item.Path
        End If
    Else
        WScript.Echo "�G���[�F" & Err.Description
    End If

    Set objFolder = Nothing
    Set objShell = Nothing
End Function



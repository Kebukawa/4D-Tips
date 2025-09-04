
//４Ｄに関するレポートファイルをリストアップする
var $files : Collection
If (Is macOS)
	$files:=Folder("/Library/Logs/DiagnosticReports/").files(fk ignore invisible+fk recursive).query("name = :1"; "4D@")
End if 

//４Ｄに関するファイルをZIPに圧縮する
var $folderToZip : 4D.Folder
var $file; $destinationFile : 4D.File
If ($files#Null) && ($files.length#0)
	//ZIPファイル化する一時フォルダーを準備
	$folderToZip:=Folder(Temporary folder+Generate UUID; fk platform path)
	$folderToZip.create()
	//４Ｄに関するファイルを一時フォルダーに集める
	For each ($file; $files)
		$file.copyTo($folderToZip)
	End for each 
	$destinationFile:=Folder(fk desktop folder).file("4D-REPORTS-"+Replace string(String(Current date); "/"; "-")+".zip")  //ZIPファイルとしての生成先にデスクトップ上の4D_REPORTS.zipを指定
	$status:=ZIP Create archive($folderToZip; $destinationFile; ZIP Without enclosing folder)
	//ZIPファイル化する一時フォルダーを削除
	$folderToZip.delete(Delete with contents)
	//生成終了のお知らせ
	CONFIRM("４Ｄに関してのレポートファイルをZIPファイルに纏めてデスクトップに保存に生成しました"; "生成したファイルをFinderで表示する"; "終了")
	If (OK=1)
		SHOW ON DISK($destinationFile.platformPath)
	End if 
Else 
	ALERT("４Ｄに関してのOSのレポートファイルは見つかりませんでした。")
End if 

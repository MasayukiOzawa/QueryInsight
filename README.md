# QueryInsight
5ms 以上、実行に時間がかかっているクエリの情報を定期的 (1 秒間隔) で取得します。  
取得したデータについては、一定の頻度でデータ格納用の SQL Server にダンプされます。

# セットアップ
1. データをダンプする SQL Server に [sql\QueryInsgiht_DDL.sql] を実行してテーブルを作成します。
1. [QueryInsight.ps1] を実行して、情報の取得を開始します。  
実行時には次のオプションの指定が必要です。
- Source : 情報取得対象の SQL Server の接続文字列 （接続先 DB は任意のもので問題ない)
- Store : 取得した情報を格納するための SQL Server の接続文字列 (DB 名は QueryInsight_DDL.sql によりテーブルを作成した DB　を指定)
```
.\QueryInsight.ps1 `
-Source "Server=xxxx;User Id=xxx;Password=xxxx;Database=master" `
-Store "Server=xxxx;User Id=xxx;Password=xxx;Database=QueryInsight"
```
3. 取得したデータの分析を行います。  
[sql\AnalyzeQuery.sql] がダンプしたデータを分析するためのサンプルクエリとなります。
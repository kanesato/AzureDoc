## Azure Database for PostgreSQL ## <br>
[ドキュメント](https://learn.microsoft.com/ja-jp/azure/postgresql/flexible-server/quickstart-create-connect-server-vnet)

・Linuxから接続CLI<br>
psql --host=<hostname> --port=<postnumber> --username=<username> --dbname=postgres --set=sslmode=require --set=sslrootcert=DigiCertGlobalRootCA.crt.pem

[Example]<br>
psql --host=self-s2s-spk02-postgre-01.postgres.database.azure.com --port=5432 --username=adminuser --dbname=postgres --set=sslmode=require --set=sslrootcert=DigiCertGlobalRootCA.crt.pem




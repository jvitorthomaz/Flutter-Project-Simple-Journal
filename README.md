# Flutter-Project-Simple-Journal
Simple Journal Project written in flutter
## 🛠️ Abrir e rodar o projeto

**Para executar este projeto você precisa:**

- Ter uma IDE, que pode ser o Android Studio ou Visual Studio Code instalado na sua máquina;
- Ter a [SDK do Flutter](https://docs.flutter.dev/get-started/install) na versão 3.0.0;
- Ter o [Node.JS](https://nodejs.org/en/) instalado na sua máquina;
- Ter um servidor [JSON-Server](https://www.npmjs.com/package/json-server) rodando o arquivo [server/db.json] em um endereço visível ao emulador usado;
- Ter um servidor [JSON-Server-Auth](https://www.npmjs.com/package/json-server-auth) rodando os arquivos [server/db.json] e [server/routes.json] em um endereço visível ao emulador usado; 

**Para executar o projeto com o servidor JSON-Server:**

- Abra o terminal na pasta do projeto e execute os comandos em sequência:
  * flutter clean;
  * flutter pub get.
- No projeto, no arquivo web_client.dart, troque onde esta escrito "Seu_endereço_IP_como_string" pelo seu endereço IP;
- Abra o terminal na pasta server e execute o comando: json-server-auth --watch --host Seu_endereço_IP_aqui db.json;
- Execute o aplicativo:
  * Pelo VS Code: Run -> Start debugging ou  Run -> Run without debugging
  * Pelo Android Studio: clicar no ícone de "Play"


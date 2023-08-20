# Mein DApp-Projekt

Dieses Repository enthält den Code für eine dezentrale Anwendung (DApp) mit Smart Contracts, die auf der Ethereum-Blockchain ausgeführt werden. Das Projekt verwendet das ThirdWeb-Framework und die Hardhat-JavaScript-Starter-Vorlage, um die Entwicklung und Bereitstellung von Smart Contracts zu erleichtern.

## Erste Schritte

Um ein neues Projekt mit diesem Beispiel zu erstellen, führen Sie den folgenden Befehl aus:

```bash
npx thirdweb create --contract --template hardhat-javascript-starter
```

Sie können die Seite bearbeiten, indem Sie `contracts/Contract.sol` ändern.

Um Ihrer Verträge zusätzliche Funktionen hinzuzufügen, können Sie das Paket `@thirdweb-dev/contracts` verwenden, das Basisverträge und Erweiterungen zum Vererben bereitstellt. Das Paket ist bereits in diesem Projekt installiert. Weitere Informationen finden Sie in unserer [Contracts Extensions Docs](https://docs.thirdweb.com/docs/contracts/extensions).

## Projekt erstellen

Führen Sie nach Änderungen am Vertrag den folgenden Befehl aus:

```bash
npm run build
# oder
yarn build
```

Dies kompiliert Ihre Verträge und erkennt auch die [Contracts Extensions Docs](https://docs.thirdweb.com/docs/contracts/extensions), die in Ihrem Vertrag erkannt wurden.

## Verträge bereitstellen

Wenn Sie Ihre Verträge bereitstellen möchten, führen Sie einen der folgenden Befehle aus, um Ihre Verträge zu bereitstellen:

```bash
npm run deploy
# oder
yarn deploy
```

## Verträge veröffentlichen

Wenn Sie eine Version Ihrer Verträge öffentlich freigeben möchten, können Sie einen der folgenden Befehle verwenden:

```bash
npm run release
# oder
yarn release
```

## Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen finden Sie in der [LICENSE](LICENSE)-Datei.